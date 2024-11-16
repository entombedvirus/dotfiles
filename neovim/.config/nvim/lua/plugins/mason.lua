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
				['ts_ls'] = function() end,
			}
		end,
	},
	{
		'neovim/nvim-lspconfig',
		config = function()
			-- vim.lsp.set_log_level(vim.log.levels.TRACE)
			-- ~/.local/state/nvim/lsp.log
			-- P(vim.lsp.get_log_path())

			local lsp_fmt_autos = vim.api.nvim_create_augroup('lsp_fmt_autos', { clear = true })
			vim.api.nvim_create_autocmd('BufWritePre', {
				desc = 'auto format files on save',
				group = lsp_fmt_autos,
				callback = function(opts)
					local file_types = {
						python = true,
						rust = true,
						lua = true,
						go = true,
						jsonnet = true,
						terraform = true,
						c = true,
						typescriptreact = false,
						typescript = true,
					}
					local current_buf = vim.bo[opts.buf].filetype
					if file_types[current_buf] == nil then
						return
					end

					local timeout_ms = 1000
					vim.lsp.buf.format({ timeout_ms = timeout_ms })

					if current_buf == 'go' then
						require('roh/lsp_utils').organize_go_imports()
					end
				end,
			})
		end,
	},
}
