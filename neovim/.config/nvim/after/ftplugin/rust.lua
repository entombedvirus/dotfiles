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
	"<leader><F5>",
	function()
		vim.cmd.RustLsp({ 'runnables' })
	end,
	{ desc = 'list runnables targets', buffer = bufnr }
)

vim.keymap.set(
	"n",
	"<space><F5>",
	function()
		vim.cmd.RustLsp({ 'run' })
	end,
	{ desc = 'run target at cursor', buffer = bufnr }
)

vim.keymap.set(
	"n",
	"<F5>",
	function()
		vim.cmd.RustLsp({ 'run', bang = true })
	end,
	{ desc = 'run last target', buffer = bufnr }
)

vim.keymap.set(
	"n",
	"<leader><F4>",
	function()
		vim.cmd.RustLsp({ 'debuggables' })
	end,
	{ desc = 'list debuggable targets', buffer = bufnr }
)

vim.keymap.set(
	"n",
	"<space><F4>",
	function()
		vim.cmd.RustLsp({ 'debug' })
	end,
	{ desc = 'debug target at cursor', buffer = bufnr }
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
