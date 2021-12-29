require('plugins')

-- set colorscheme before editor settings since colorscheme-s can set global
-- vars that are then used in editor_settings.
require('settings.colorscheme')
vim.cmd('source ~/cl/neovim/.config/nvim/editor_settings.vim')
