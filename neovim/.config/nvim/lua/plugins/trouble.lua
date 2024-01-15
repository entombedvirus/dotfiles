return {
	'folke/lsp-trouble.nvim',
	dependencies = "kyazdani42/nvim-web-devicons",
	config = function()
		require('trouble').setup()
		vim.keymap.set(
			'n',
			'<space>d',
			'<cmd>TroubleToggle document_diagnostics<cr>'
		)
		vim.keymap.set(
			'n',
			'<space>wd',
			'<cmd>TroubleToggle workspace_diagnostics<cr>'
		)
	end
}
