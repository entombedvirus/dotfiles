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
	"<F5>",
	function()
		vim.cmd.RustLsp({ 'run', bang = true })
	end,
	{ silent = true, buffer = bufnr }
)

vim.keymap.set(
	"n",
	"<F4>",
	function()
		vim.cmd.RustLsp({ 'debug', bang = true })
	end,
	{ silent = true, buffer = bufnr }
)

vim.keymap.set(
	"n",
	"<space>ha",
	function()
		vim.cmd.RustLsp({ 'hover', 'actions' })
	end,
	{ silent = true, buffer = bufnr }
)

vim.keymap.set(
	"n",
	"<space>ca",
	function()
		vim.cmd.RustLsp({ 'codeAction' })
	end,
	{ silent = true, buffer = bufnr }
)
