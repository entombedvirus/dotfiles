return {
	{
		'milanglacier/minuet-ai.nvim',
		opts = {
			provider = "claude",
			virtualtext = {
				auto_trigger_ft = {},
				keymap = {
					-- accept whole completion
					accept = '<A-A>',
					-- accept one line
					accept_line = '<A-a>',
					-- accept n lines (prompts for number)
					-- e.g. "A-z 2 CR" will accept 2 lines
					accept_n_lines = '<A-z>',
					-- Cycle to prev completion item, or manually invoke completion
					prev = '<A-[>',
					-- Cycle to next completion item, or manually invoke completion
					next = '<A-]>',
					dismiss = '<A-e>',
				},
			},
		},
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- optional, if you are using virtual-text frontend, nvim-cmp is not
			-- required.
			{ 'hrsh7th/nvim-cmp' },
			-- optional, if you are using virtual-text frontend, blink is not required.
			-- { 'Saghen/blink.cmp' },
		}
	},
}
