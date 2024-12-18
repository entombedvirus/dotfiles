return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	config = function()
		local lsp_utils = require("roh/lsp_utils")
		local opts = lsp_utils.get_lsp_opts("typescript-tools")
		require("typescript-tools").setup(opts)
	end,
}
