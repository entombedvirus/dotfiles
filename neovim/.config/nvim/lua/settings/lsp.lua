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

	local s = server.Server:new {
		name = server_name,
		root_dir = root_dir,
		homepage = 'https://github.com/entombedvirus/jsonnet-language-server',
		languages = { 'jsonnet', 'libsonnet' },
		async = true,
		installer = function(ctx)
			git.clone({ 'https://github.com/entombedvirus/jsonnet-language-server.git' })
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

-- advertise that we have a snippet plugin installed to the default lsp client
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap = true, silent = true }
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', '<c-space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('i', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', '<localleader>gd', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)

	buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>l', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)

	-- Set some keybinds conditional on server capabilities
	if client.server_capabilities.documentFormattingProvider then
		buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
		vim.api.nvim_exec([[
          augroup lsp_fmt_autos
            autocmd!
            autocmd BufWritePre *.py,*.rs lua vim.lsp.buf.formatting_sync(nil, 10000)
            autocmd BufWritePre *.go lua Goimports(1000)
          augroup END
        ]], false)
	end

	-- if client.resolved_capabilities.code_lens then
	--     vim.api.nvim_exec([[
	--       augroup lsp_code_lens
	--         autocmd!
	--         autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
	--       augroup END
	--     ]], false)
	--     buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.codelens.run()<CR>', opts)
	-- end

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_exec([[
          augroup lsp_document_highlight
            autocmd!
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
        ]], false)
	end
end

--[[ Go ]] --
function Goimports(timeout_ms)
	local gopls_client = vim.tbl_filter(function(client)
		return client.name == 'gopls'
	end, vim.lsp.get_active_clients())

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

	vim.lsp.buf.formatting_sync(nil, timeout_ms)
end

local function get_lsp_opts(lang)
	local flags = {
		debounce_text_changes = 250,
		-- debounce_text_changes = 3000,
	}

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	do
		local ok, cmp = pcall(require, 'cmp_nvim_lsp')
		if ok then
			capabilities = cmp.update_capabilities(capabilities)
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
					underline        = false,
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
			}
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
