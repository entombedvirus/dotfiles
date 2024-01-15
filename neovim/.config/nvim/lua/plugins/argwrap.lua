return {
	'FooSoft/vim-argwrap',
	config = function()
		vim.g.argwrap_tail_comma = 1
		vim.keymap.set('n', '<leader>w', '<cmd>ArgWrap<cr>', { silent = true })
	end,
}
