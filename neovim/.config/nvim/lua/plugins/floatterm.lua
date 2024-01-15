return {
	'voldikss/vim-floaterm',
	init = function()
		vim.g.floaterm_keymap_toggle = [[<leader>t]]
		vim.cmd [[highlight link FloatermBorder FloatBorder]]
	end,
}
