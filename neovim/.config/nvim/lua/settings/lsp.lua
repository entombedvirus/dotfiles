if not pcall(require, 'nvim-lsp-installer') then
	return
end

-- installer for custom fork of jsonnet-language-server that supports extvars
do
	local server_name = 'my_jsonnet_ls'
	local server = require "nvim-lsp-installer.server"
	local root_dir = server.get_server_root_path(server_name)
	local git = require "nvim-lsp-installer.core.managers.git"
	local path = require "nvim-lsp-installer.core.path"
	local Optional = require "nvim-lsp-installer.core.optional"

	local s = server.Server:new {
		name = server_name,
		root_dir = root_dir,
		homepage = 'https://github.com/entombedvirus/jsonnet-language-server',
		languages = { 'jsonnet', 'libsonnet' },
		async = true,
		installer = function(ctx)
			git.clone({
				'https://github.com/entombedvirus/jsonnet-language-server.git',
				version = Optional.new('allow-fmt-customization'),
			})
			ctx.spawn.go {
				"build", ".",
				cwd = ctx.install_dir,
				stdio_sink = ctx.stdio_sink,
			}
		end,
	}

	local servers = require "nvim-lsp-installer.servers"
	servers.register(s)

	-- common jsonnet library paths
	local function jsonnet_path(parent_dir)
		local paths = {
			path.concat { parent_dir, 'lib' },
			path.concat { parent_dir, 'vendor' },
		}
		return table.concat(paths, ':')
	end

	local configs = require "lspconfig.configs"
	local util = require 'lspconfig.util'
	configs[s.name] = {
		default_config = {
			cmd = { path.concat { root_dir, "jsonnet-language-server" } },
			filetypes = s.languages,
			root_dir = function(fname)
				return util.root_pattern 'Makefile' (fname) or util.find_git_ancestor(fname)
			end,
			on_new_config = function(new_config, file_root_dir)
				new_config.cmd_env = {
					JSONNET_PATH = jsonnet_path(file_root_dir),
				}
			end,
		},
	}
end

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
	'my_jsonnet_ls',
	'rust_analyzer',
	'sumneko_lua',
	'tsserver',
	'vimls',
	'yamlls',
}

require("nvim-lsp-installer").setup({
	ensure_installed = lsp_servers, -- ensure these servers are always installed
	automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
})

if not pcall(require, 'lspconfig') then
	return
end

-- vim.lsp.set_log_level(vim.log.levels.TRACE)

--[[ Go ]] --
local function goOrganizeImports()
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
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<c-space>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', '<c-]>', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gD', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<localleader>gd', vim.lsp.buf.document_symbol, opts)

	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
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
			capabilities = cmp.update_capabilities(capabilities)
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
	}

	if lang == "efm" then
		opts = {
			on_attach    = on_attach,
			capabilities = capabilities,
			flags        = flags,
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
		opts = {
			cmd          = { 'gopls', '-remote=auto' },
			on_attach    = on_attach,
			flags        = flags,
			capabilities = capabilities,
			settings     = {
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
					--buildFlags = {
					--    -- enable completion is avo files
					--    "-tags=avo",
					--},
				},
			},
			handlers     = {
				-- ["textDocument/publishDiagnostics"] = noop,
				["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					-- delay update diagnostics
					update_in_insert = false,
					virtual_text     = true,
					underline        = true,
				}),
			},
		}

	elseif lang == "my_jsonnet_ls" then
		opts.settings = {
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
		}

	elseif lang == "sumneko_lua" then
		-- Make runtime files discoverable to the server
		local runtime_path = vim.split(package.path, ';')
		table.insert(runtime_path, 'lua/?.lua')
		table.insert(runtime_path, 'lua/?/init.lua')
		opts.settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
					-- Setup your lua path
					path = runtime_path,
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { 'vim', 'P', 'RELOAD', 'R' },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file('', true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		}
	end

	return opts
end

local lspconfig = require('lspconfig')
for _, name in pairs(lsp_servers) do
	local opts = get_lsp_opts(name)
	if name == "rust_analyzer" then
		-- See: https://github.com/simrat39/rust-tools.nvim#initial-setup
		-- Initialize the LSP via rust-tools instead
		require("rust-tools").setup {
			server = opts
		}
	else
		lspconfig[name].setup(opts)
	end
end

local lsp_fmt_autos = vim.api.nvim_create_augroup('lsp_fmt_autos', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
	group = lsp_fmt_autos,
	pattern = { '*.py', '*.rs', '*.lua', '*.go', '*.jsonnet', '*.libsonnet' },
	callback = function(ev)
		local function ends_with(str, ending)
			return ending == "" or str:sub(- #ending) == ending
		end

		local timeout_ms = 1000
		if ends_with(ev.file, '.py') then
			timeout_ms = 10000
		end

		vim.lsp.buf.format {
			async = false,
			timeout_ms = timeout_ms,
		}

		if ends_with(ev.file, '.go') then
			goOrganizeImports()
		end
	end,
})
