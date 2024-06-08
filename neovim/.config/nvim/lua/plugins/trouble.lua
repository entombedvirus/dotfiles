return {
	'folke/lsp-trouble.nvim',
	dependencies = "kyazdani42/nvim-web-devicons",
	opts = {}, -- for default options, refer to the configuration section for custom setup.
	keys = {
		{
			'<space>d',
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			'<space>wd',
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
	}
}
