return {
	"mrcjkb/rustaceanvim",
	ft = { "rust" },
	version = "^5", -- Recommended
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
	keys = {
		{
			"<leader>rd",
			function() vim.cmd.RustLsp('debuggables') end,
			ft = "rust",
			silent = true,
			desc = "list and run debuggable targets"
		},
		{
			"<leader><F5>",
			function() vim.cmd.RustLsp({ 'runnables' }) end,
			ft = "rust",
			silent = true,
			desc = "list and run runnable targets"
		},
		{
			"<space><F5>",
			function() vim.cmd.RustLsp({ 'run' }) end,
			ft = "rust",
			silent = true,
			desc = "run target at cursor"
		},
		{
			"<F5>",
			function() vim.cmd.RustLsp({ 'run', bang = true }) end,
			ft = "rust",
			silent = true,
			desc = "run last target"
		},
		{
			"<leader><F4>",
			function() vim.cmd.RustLsp({ 'debuggables' }) end,
			silent = true,
			desc = "list debuggable targets"
		},
		{
			"<space><F4>",
			function()
				vim.cmd.RustLsp({ 'debug' })
			end,
			silent = true,
			desc = 'debug target at cursor'
		},
		{
			"<F4>",
			function() vim.cmd.RustLsp({ 'debug', bang = true }) end,
			silent = true,
			desc = 'debug last target'
		},
		{
			"<space>ha",
			function() vim.cmd.RustLsp({ 'hover', 'actions' }) end,
			silent = true,
			desc = 'show hover actions at cursor'
		},
		{
			"<space>ca",
			function()
				vim.cmd.RustLsp({ 'codeAction' })
			end,
			silent = true,
			desc = 'show code actions at cursor'
		}
	},
}
