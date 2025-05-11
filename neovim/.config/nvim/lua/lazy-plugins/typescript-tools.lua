return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	config = function()
		local opts = vim.lsp.config["*"]
		require("typescript-tools").setup(opts)
	end,
}
