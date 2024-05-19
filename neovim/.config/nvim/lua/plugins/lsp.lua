--[[ Go ]]
local function organize_go_imports()
	local gopls_client = vim.lsp.get_active_clients({ name = 'gopls' })
	if not gopls_client or not gopls_client[1] then
		vim.notify('GoImports: gopls is not attached to buffer', vim.log.levels.WARN)
		return
	end
	gopls_client = gopls_client[1]

	local function apply_action(action)
		-- textDocument/codeAction can return either Command[] or CodeAction[]. If it
		-- is a CodeAction, it can have either an edit, a command or both. Edits
		-- should be executed first.
		if action.edit or type(action.command) == "table" then
			if action.edit then
				vim.lsp.util.apply_workspace_edit(action.edit, gopls_client.offset_encoding)
			end
			if type(action.command) == "table" then
				vim.lsp.buf.execute_command(action.command)
			end
		else
			vim.lsp.buf.execute_command(action)
		end
	end

	-- See the implementation of the textDocument/codeAction callback
	-- (lua/vim/lsp/handler.lua) for how to do this properly.
	local context = { source = { organizeImports = true } }
	vim.validate { context = { context, "t", true } }

	local params = vim.lsp.util.make_range_params()
	params.context = context

	local timeout_ms = 1000
	local result, err = gopls_client.request_sync("textDocument/codeAction", params, timeout_ms)
	if result then
		for _, actions in pairs(result) do
			for _, action in ipairs(actions) do
				if action.kind == "source.organizeImports" then
					apply_action(action)
				end
			end
		end
	elseif err then
		vim.notify('GoImports: ' .. err, vim.log.levels.WARN)
	end
end

-- advertise that we have a snippet plugin installed to the default lsp client
local on_attach = function(client, bufnr)
	if client.name == 'rust-analyzer' then
		client.server_capabilities.semanticTokensProvider = nil
	end

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap = true, silent = true, buffer = bufnr }
	local special_mappings = {
		lsp_definitions = vim.lsp.buf.definition,
		lsp_implementations = vim.lsp.buf.implementation,
		lsp_type_definitions = vim.lsp.buf.type_definition,
		lsp_references = vim.lsp.buf.references,
		lsp_document_symbols = vim.lsp.buf.document_symbol,
	}
	do
		local has_telescope, builtin = pcall(require, 'telescope.builtin')
		if has_telescope then
			local telescope_opts = {
				lsp_definitions = { fname_width = 0.3 },
				lsp_references = { fname_width = 0.3 },
				lsp_type_definitions = { fname_width = 0.3 },
				lsp_implementations = { fname_width = 0.3 },
				lsp_document_symbols = require('telescope.themes').get_dropdown()
			}
			for func_name in pairs(special_mappings) do
				special_mappings[func_name] = function()
					builtin[func_name](telescope_opts[func_name])
				end
			end
		end
	end

	vim.keymap.set('n', '<c-]>', special_mappings.lsp_definitions, opts)
	vim.keymap.set('n', 'gD', special_mappings.lsp_implementations, opts)
	vim.keymap.set('n', '<space>D', special_mappings.lsp_type_definitions, opts)
	vim.keymap.set('n', 'gr', special_mappings.lsp_references, opts)
	vim.keymap.set('n', '<localleader>gd', special_mappings.lsp_document_symbols, opts)

	vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<c-space>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('i', '<c-y>', vim.lsp.buf.signature_help, opts)

	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
		opts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<space>l', vim.diagnostic.setloclist, opts)
	vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format({ timeout_ms = 10000 }) end, opts)

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		local lsp_highlight_autos = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
		vim.api.nvim_create_autocmd('CursorHold', {
			group = lsp_highlight_autos,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd('CursorMoved', {
			group = lsp_highlight_autos,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

local function get_lsp_opts(lang)
	local flags = {
		debounce_text_changes = 250,
		-- debounce_text_changes = 3000,
	}

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	do
		-- autocomplete
		local ok, cmp = pcall(require, 'cmp_nvim_lsp')
		if ok then
			capabilities = vim.tbl_deep_extend("force", capabilities, cmp.default_capabilities())
		end

		-- folds
		if pcall(require, 'ufo') then
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true
			}
		end
	end

	local opts = {
		on_attach    = on_attach,
		capabilities = capabilities,
		flags        = flags,
		handlers     = {
			-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			}),

			["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
				-- delay update diagnostics
				update_in_insert = false,
				virtual_text     = true,
				underline        = true,
			}),
		},
	}

	local overrides = {}
	if lang == "efm" then
		overrides = {
			init_options = {
				documentFormatting = true,
			},
			filetypes    = { "python" },
			settings     = {
				rootMarkers = { ".git/" },
				languages = {
					python = {
						{
							formatCommand      = './tools/black --quiet -',
							formatStdin        = true,
							lintCommand        = './tools/flake8 --stdin-display-name ${INPUT} -',
							lintStdin          = true,
							lintFormats        = { '%f:%l:%c: %m' },
							lintIgnoreExitCode = true,
						},
					},
				}
			}
		}
	elseif lang == "gopls" then
		overrides = {
			cmd      = { 'gopls', '-remote=auto' },
			settings = {
				gopls = {
					usePlaceholders    = true,
					completeUnimported = true,
					-- experimentalDiagnosticsDelay = "0ms",
					codelenses         = {
						generate           = false,
						gc_details         = false,
						test               = false,
						tidy               = false,
						vendor             = false,
						upgrade_dependency = false,
					},
					hints              = {
						assignVariableTypes    = true,
						functionTypeParameters = true,
						parameterNames         = true,
						rangeVariableTypes     = true,
					},
					--buildFlags = {
					--    -- enable completion is avo files
					--    "-tags=avo",
					--},
				},
			},
		}
	elseif lang == "jsonnet_ls" then
		local util = require 'lspconfig.util'

		overrides.root_dir = function(fname)
			return util.root_pattern 'Makefile' (fname) or util.find_git_ancestor(fname)
		end

		overrides.on_new_config = function(new_config, file_root_dir)
			-- common jsonnet library paths
			new_config.settings.jpath = {
				util.path.join { file_root_dir, 'lib' },
				util.path.join { file_root_dir, 'vendor' },
			}
		end

		overrides.settings = {
			-- without these ext_vars, lsp parsing of jsonnet files will break
			ext_vars = {
				gcpProject = 'dummy_gcp_project',
				arbCluster = 'dummy_arb_cluter',
				kubeCluster = 'dummy_cluster',
				namespace = 'dummy_namespace',
				containerProject = 'dummy_container_project',
				registry = 'us.gcr.io/dummy_registry',
			},
			formatting = {
				Indent = 4,
				StringStyle = 'double',
			},
			enable_eval_diagnostics = true,
			enable_lint_diagnostics = true,
		}
	elseif lang == "lua_ls" then
		-- Make runtime files discoverable to the server
		overrides.settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
					-- Setup your lua path
					-- path = runtime_path,
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { 'vim', 'P', 'RELOAD', 'R' },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					-- library = vim.api.nvim_get_runtime_file('', true),
					library = { vim.env.VIMRUNTIME },
					checkThirdParty = false,
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		}
	elseif lang == "rust_analyzer" then
		overrides.settings = {
			["rust-analyzer"] = {
				inlayHints = {
					bindingModeHints = {
						enable = true,
					},
					lifetimeElisionHints = {
						enable = true,
					},
				}
			}
		}
	elseif lang == "clangd" then
		-- suppress "warning: multiple different client offset_encodings detected for buffer, this is not supported yet" warning
		-- See: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-997234900
		overrides.capabilities = { offsetEncoding = { "utf-16" } }
	end

	return vim.tbl_deep_extend("force", opts, overrides)
end

return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		'neovim/nvim-lspconfig',
		-- provides lsp progress notification toasts
		{
			'j-hui/fidget.nvim',
			tag = 'v1.2.0',
			config = function()
				require('fidget').setup({})
			end,
		},
	},
	config = function()
		local lsp_servers = {
			'bashls',
			'clangd',
			'cssls',
			'dockerls',
			'efm',
			'gopls',
			'grammarly',
			'html',
			'jsonls',
			'jsonnet_ls',
			'rust_analyzer',
			'lua_ls',
			'tsserver',
			'terraformls',
			'vimls',
			'yamlls',
		}

		-- order is important; mason -> mason-lspconfig -> lspconfig
		require("mason").setup {}
		require("mason-lspconfig").setup {
			ensure_installed = lsp_servers, -- ensure these servers are always installed
			automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
		}
		require("lspconfig")

		-- vim.lsp.set_log_level(vim.log.levels.TRACE)

		local lspconfig = require('lspconfig')
		for _, name in pairs(lsp_servers) do
			local opts = get_lsp_opts(name)
			if name == "rust_analyzer" then
				-- this configuration is automatically picked up by rustacean plugin when
				-- rust files are loaded and we must not call any setup method
				vim.g.rustaceanvim = {
					-- Plugin configuration
					-- inlay_hints = {
					-- 	highlight = "NonText",
					-- },
					tools = {
						hover_actions = {
							auto_focus = true,
						},
						test_executor = require('custom_rust_test_executor'),
					},
					-- LSP configuration
					server = opts,
					-- on_attach = on_attach,
					dap = {
						autoload_configurations = true,
					}
				}
			else
				lspconfig[name].setup(opts)
			end
		end

		local lsp_fmt_autos = vim.api.nvim_create_augroup('lsp_fmt_autos', { clear = true })
		vim.api.nvim_create_autocmd('BufWritePre', {
			group = lsp_fmt_autos,
			pattern = { '*.py', '*.rs', '*.lua', '*.go', '*.jsonnet', '*.libsonnet', '*.tf', '*.tfvars', '*.c', '*.h' },
			callback = function(ev)
				local function ends_with(str, ending)
					return ending == "" or str:sub(- #ending) == ending
				end

				local timeout_ms = 1000
				if ends_with(ev.file, '.py') then
					timeout_ms = 10000
				end

				vim.lsp.buf.format({ timeout_ms = timeout_ms })

				if ends_with(ev.file, '.go') then
					organize_go_imports()
				end
			end,
		})
	end,

}
