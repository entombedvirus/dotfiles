return {
	'justinmk/vim-sneak',
	init = function()
		vim.g['sneak#label'] = 1

		-- " 2-character Sneak (don't let vim-sneak take s)
		vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>Sneak_s')
		vim.keymap.set({ 'n', 'x', 'o' }, 'F', '<Plug>Sneak_S')
	end,
}
