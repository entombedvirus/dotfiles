return {
	"williamboman/mason.nvim",
	dependencies = {
		{

			"williamboman/mason-lspconfig.nvim",
			config = function()
				-- disable setting up of rust lsp since that is handled by rustacean.nvim
				require('mason-lspconfig').setup_handlers {
					['rust_analyzer'] = function() end,
				}
			end,
		},
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

		-- vim.lsp.set_log_level(vim.log.levels.TRACE)

		local lspconfig = require('lspconfig')
		for _, name in pairs(lsp_servers) do
			-- skipping rust_analyzer here to let rustacean setup the lspconfig
			if name ~= "rust_analyzer" then
				local opts = require("roh/lsp_utils").get_lsp_opts(name)
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
