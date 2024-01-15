return {
	'vim-test/vim-test',
	config = function()
		vim.g["test#strategy"] = "floaterm"
		-- execute tests from package dir
		vim.g["test#project_root"] = "%:h"
		vim.keymap.set('n', '<leader>gtf', '<cmd>TestNearest<cr>')
		vim.keymap.set('n', '<leader>gtl', '<cmd>TestLast<cr>')
		vim.keymap.set('n', '<leader>gt', '<cmd>TestFile<cr>')
	end,
}
