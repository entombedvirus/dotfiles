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
	'rust_analyzer',
	'lua_ls',
	'tsserver',
	'terraformls',
	'vimls',
	'yamlls',
}

return {
	{
		"williamboman/mason.nvim",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			-- order is important; mason -> mason-lspconfig -> lspconfig
			require('mason').setup({})
			require('mason-lspconfig').setup_handlers {
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					local opts = require("roh/lsp_utils").get_lsp_opts(server_name)
					require("lspconfig")[server_name].setup(opts)
				end,
				-- disable setting up of rust lsp since that is handled by rustacean.nvim
				['rust_analyzer'] = function() end,
			}
		end,
	},
	{
		'neovim/nvim-lspconfig',
		config = function()
			-- vim.lsp.set_log_level(vim.log.levels.TRACE)

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
						require('roh/lsp_utils').organize_go_imports()
					end
				end,
			})
		end,
	},
}
