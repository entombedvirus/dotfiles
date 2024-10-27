return {
	'voldikss/vim-floaterm',
	init = function()
		vim.g.floaterm_keymap_toggle = [[<leader>t]]
		vim.cmd [[autocmd FileType floaterm nnoremap [ :FloatermPrev<cr>]]
		vim.cmd [[autocmd FileType floaterm nnoremap ] :FloatermNext<cr>]]
		vim.cmd [[highlight link FloatermBorder FloatBorder]]
	end,
}
