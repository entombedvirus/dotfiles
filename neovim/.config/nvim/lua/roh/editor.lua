local group = vim.api.nvim_create_augroup('editor_settings_user_config', { clear = true })
vim.api.nvim_create_autocmd(
	'BufWritePost',
	{
		command = 'source <afile> | redraw',
		group = group,
		-- add the HOME prefix so it won't catch fugitive:/// style paths
		pattern = { os.getenv('HOME') .. '/*/editor.lua' },
	}
)

vim.api.nvim_create_autocmd(
	'TextYankPost',
	{
		desc = 'Highlight when yanking (copying) text',
		callback = function()
			vim.highlight.on_yank()
		end,
		group = group,
	}
)

vim.api.nvim_create_autocmd(
	'BufWritePre',
	{
		callback = function()
			if vim.fn.exists(":StripWhitespace") == 2 then
				vim.cmd('StripWhitespace')
			end
		end,
		group = group,
		pattern = '*',
		desc = 'Automatically strip trailing whitespace',
	}
)


vim.api.nvim_create_autocmd(
	{ 'BufNewFile', 'BufRead' },
	{
		callback = function()
			vim.bo.filetype = 'gitcommit'
		end,
		group = group,
		pattern = 'COMMIT_EDITMSG',
		desc = 'Auto-detect git commit messages',
	}
)


vim.g.mapleader = [[\]]

-- disable the built-in showing of mode in the command bar since airline will
-- take care of that
vim.o.showmode = false
vim.o.ruler = false

-- show both absolute current line no and relative numbers
vim.o.number = true
vim.o.relativenumber = true

-- for letting swtich away from a modified buffer w/o warning
vim.o.hidden = true

-- for highlighting search word
vim.o.hlsearch = true

-- always show gitgutter col so text doesn't jump around when they come in
vim.o.signcolumn = 'yes'

-- Show invisible chars
vim.o.list = true

-- Use the same symbols as TextMate for tabstops and EOLs
vim.opt.listchars = { tab = '» ', eol = '¬' }

vim.o.title = true

-- Always show the status line (even if no split windows)
vim.o.laststatus = 2

-- Number of lines to keep between cursor and window boundary before scrolling
-- kicks in.
vim.o.scrolloff = 7

-- Number of lines to jump when scrolling. Improves rendering speed
vim.o.scrolljump = 5

-- expandtab, tabstop, softtabstop, shiftwidth settings are managed by
-- tpope/sleuth.vim
vim.o.shiftround = true

-- turn mouse on
vim.o.mouse = 'a'

-- persistent undo file
vim.o.undofile = true
-- the ]//" at the end of each directory means that file names will be built
-- from the complete path to the file with all path separators substituted to
-- percent "%" sign. This will ensure file name uniqueness in the preserve
-- directory.
vim.o.backup = true
vim.o.writebackup = true
vim.o.undodir = vim.fn.stdpath('data') .. '/undo//'
vim.o.backupdir = vim.fn.stdpath('data') .. '/backup//'
vim.o.directory = vim.fn.stdpath('data') .. '/swp//'
vim.fn.system({ 'mkdir', '-p', vim.o.undodir, vim.o.backupdir, vim.o.directory })

-- folding settings
vim.o.foldmethod = 'indent'
vim.o.foldlevelstart = 20

-- misc
vim.o.incsearch = true
vim.o.wrapscan = false
vim.o.wrap = false

-- default is 4000 (4s), which is too long to wait to trigger events
-- like "CursorHold"
vim.o.updatetime = 300

vim.opt.wildignore:append({ '*.pyc', '*.o', '*.a', '*.clj' })

-- sync to system clipboard
vim.o.clipboard = 'unnamedplus'

-- spell check
vim.opt.spell = false -- used on-demand
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = "camel"

-- prefer vertical splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- tab stuff
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = false

-- For conceal markers.
if vim.fn.has('conceal') == 1 then
	-- hide concealed chars, except in insert, visual and command modes
	vim.o.conceallevel = 2
	vim.o.concealcursor = 'n'
end

-- prevent "Press enter to continue" message on auto type info
vim.o.cmdheight = 2
vim.o.showtabline = 2

-- use ripgrep, if available
if vim.fn.executable('rg') == 1 then
	vim.o.grepprg =
	[[rg --type-not=html --type-not=js --type-not=css --type-not=clojure --glob="!vendor/*" --vimgrep $*]]
	vim.o.grepformat = "%f:%l:%c:%m"
end


local function inoremap(lhs, rhs)
	vim.keymap.set('i', lhs, rhs, { silent = true })
end

local function nnoremap(lhs, rhs)
	vim.keymap.set('n', lhs, rhs, { silent = true })
end

local function xnoremap(lhs, rhs)
	vim.keymap.set('x', lhs, rhs, { silent = true })
end

local function snoremap(lhs, rhs)
	vim.keymap.set('s', lhs, rhs, { silent = true })
end

local function imap(lhs, rhs)
	vim.keymap.set('n', lhs, rhs, { silent = true, remap = true })
end

local function vmap(lhs, rhs)
	vim.keymap.set('v', lhs, rhs, { silent = true, remap = true })
end

local function omap(lhs, rhs)
	vim.keymap.set('o', lhs, rhs, { silent = true, remap = true })
end

local function smap(lhs, rhs)
	vim.keymap.set('s', lhs, rhs, { silent = true, remap = true })
end

-- quick save
nnoremap('<leader>s', '<cmd>write<cr>')

-- " jump to beginning of line
nnoremap('H', '^')
xnoremap('H', '^')

-- " jump to end of line
nnoremap('L', '$')
xnoremap('L', '$')

-- " when in wrap mode, move wrapped lines
nnoremap('j', 'gj')
nnoremap('k', 'gk')

-- " emulate vim-surround's aliases:
-- " r -> [ ]
vmap('ar', ':<c-u>normal va]<cr>')
omap('ar', ':normal va]<cr>')
vmap('ir', ':<c-u>normal vi]<cr>')
omap('ir', ':normal vi]<cr>')
-- " a -> < >
vmap('aa', ':<c-u>normal va><cr>')
omap('aa', ':normal va><cr>')
vmap('ia', ':<c-u>normal vi><cr>')
omap('ia', ':normal vi><cr>')

-- " CTRL-C doesn't trigger the InsertLeave autocmd. map to <ESC> instead.
inoremap('<c-c>', '<ESC>')

-- " start profile
nnoremap('<leader>pr', ':profile start /tmp/profile.log<cr>:profile func *<cr>:profile file *<cr>')

-- " quickfix nav
nnoremap('[]', ':cclose<cr>')
nnoremap('][', ':copen<cr>')

-- " location list nav
nnoremap('()', ':lclose<cr>')
nnoremap(')(', ':lopen<cr>')

-- " tab pages
nnoremap('<leader>]t', ':tabnew<cr>')
nnoremap('<leader>]c', ':tabclose<cr>')

-- " For vim-workspace
nnoremap('<leader>S', ':mksession! /tmp/sess.vim<CR>:qa<CR>')

-- " cycle between buffers faster
nnoremap('<Tab><Tab>', '<C-W>w')

-- " Some emacs keybindings thats used all over OS X
-- " delete one char in front
inoremap('<C-d>', '<Delete>')

-- " jump to start and end of line in insert mode
inoremap('<C-a>', '<C-o>I')
inoremap('<C-e>', '<C-o>A')

-- " move one char left or right while in insert mode
inoremap('<C-f>', '<C-o>l')
-- " conflicts with delete char
-- " inoremap <C-d> <C-o>h

-- " duplicate current line
nnoremap('<D-d>', 'mz"zY"zP`z')
inoremap('<D-d>', '<Esc>mz"zY"zP`za')
xnoremap('<D-d>', 'mz"zy`>"zp`zgv')

-- " reformat JSON
nnoremap('<leader>jt', '<Esc>:%!jq<CR>')

-- select mode surround with quotes
snoremap('"', [[""<esc>i]])
snoremap("'", [[''<esc>i]])
snoremap("[", [[[]<esc>i]])
snoremap("(", [[()<esc>i]])
snoremap("{", [[{}<esc>i]])
-- in select mode, ctrl-s:
--	first switches to visual mode (<c-g>)
--	deletes selection and enters insert mode (s)
--	starts surround mode (<c-s>)
smap("<C-s>", [[<C-g>s<C-s>]])

-- double tap escape to escape terminal mode
vim.keymap.set('t', "<esc><esc>", "<C-\\><C-n>")
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- " Common typos
local command = vim.api.nvim_create_user_command
command('Q', 'quit', { desc = 'fat finger aliases' })
command('W', 'write', { desc = 'fat finger aliases' })
command('Wq', 'wq', { desc = 'fat finger aliases' })
command('Cq', 'cq', { desc = 'fat finger aliases' })

-- " destroy add buffers
nnoremap('<leader>bd', ':bufdo bd<cr>')

local function close_hidden_bufs(cmd)
	for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = true })) do
		if buf.hidden == 1 or buf.loaded == 0 then
			local ok = pcall(vim.api.nvim_buf_delete, buf.bufnr, { force = cmd.bang })
			if not ok then
				return
			end
		end
	end
end

command('CloseHiddenBuffers', close_hidden_bufs, { bang = true })
