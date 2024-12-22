return {
	'voldikss/vim-floaterm',
	init = function()
		vim.g.floaterm_keymap_toggle = [[<leader>t]]
		-- double tap escape to escape terminal mode
		vim.cmd [[autocmd FileType floaterm tnoremap <buffer> <esc><esc> <c-\><c-n>]]
		vim.cmd [[autocmd FileType floaterm nnoremap <buffer> <c-t> <cmd>FloatermNew<cr>]]
		vim.cmd [[autocmd FileType floaterm nnoremap <buffer> <c-p> <cmd>FloatermPrev<cr><c-\><c-n>]]
		vim.cmd [[autocmd FileType floaterm nnoremap <buffer> <c-n> <cmd>FloatermNext<cr><c-\><c-n>]]
		vim.cmd [[highlight link FloatermBorder FloatBorder]]
	end,
}
