local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
	"n",
	"<leader>rd",
	function()
		vim.cmd.RustLsp('debuggables')
	end,
	{ silent = true, buffer = bufnr }
)

vim.keymap.set(
	"n",
	"<leader>rdl",
	function()
		vim.cmd.RustLsp({ 'debuggables', 'last' })
	end,
	{ silent = true, buffer = bufnr }
)
