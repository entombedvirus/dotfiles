require('plugins')
require('roh.globals')

-- Turn off builtin plugins I do not use.
require "roh.disable_builtin"

vim.cmd('runtime lua/settings/editor.vim')
require('settings.colorscheme')
