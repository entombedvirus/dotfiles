return {
	"mrcjkb/rustaceanvim",
	ft = { "rust" },
	version = "^4", -- Recommended
	dependencies = {
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
	},
	config = function()
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
			server = require("roh/lsp_utils").get_lsp_opts("rust-analyzer"),
			-- on_attach = on_attach,
			dap = {
				autoload_configurations = true,
			}
		}
	end,
}
