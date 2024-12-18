return {
	'voldikss/vim-floaterm',
	init = function()
		vim.g.floaterm_keymap_toggle = [[<leader>t]]
		vim.cmd [[autocmd FileType floaterm nnoremap <c-t> <cmd>FloatermNew<cr>]]
		vim.cmd [[autocmd FileType floaterm nnoremap <c-p> <cmd>FloatermPrev<cr><c-\><c-n>]]
		vim.cmd [[autocmd FileType floaterm nnoremap <c-n> <cmd>FloatermNext<cr><c-\><c-n>]]
		vim.cmd [[highlight link FloatermBorder FloatBorder]]
	end,
}
