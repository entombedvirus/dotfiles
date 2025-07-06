return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	config = function()
		-- ensure that the lsp settings is loaded so that we can re-use it
		require("roh/lsp")
		local opts = vim.lsp.config["*"]
		assert(not vim.tbl_isempty(opts), "LSP settings not found for typescript-tools.nvim")

		local base_on_attach = opts.on_attach
		require("typescript-tools").setup(vim.tbl_deep_extend('force', opts, {
			on_attach = function(client, bufnr)
				if (base_on_attach ~= nil) then
					base_on_attach(client, bufnr)
				end
				-- prevent duplicate diagnostic from both eslint and typescript-tools by
				-- disabling one of them. eslint diagnostics seems like a super set, so
				-- disabling typescript-tools' diagnostics
				local ns_id = vim.lsp.diagnostic.get_namespace(client.id)
				vim.diagnostic.enable(false, {
					ns_id = ns_id,
					bufnr = bufnr,
				})
			end
		}))
	end,
}
