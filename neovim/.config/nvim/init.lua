require('roh.globals')

-- Turn off builtin plugins I do not use.
require 'roh.disable_builtin'

-- TODO: convert over to lua
vim.cmd('runtime lua/settings/editor.vim')

-- local packer_install_group = vim.api.nvim_create_augroup('PackerInstallUserRoh', { clear = true })
-- vim.api.nvim_create_autocmd(
--     'User PackerComplete',
--     {
--         callback = function()
--             -- require('settings.colorscheme')
--         end,
--         group = packer_install_group,
--         once = true,
--     }
-- )

local ok, msg = pcall(require, 'plugins')
if not ok then
    vim.notify('plugins: ' .. msg)
    return
end
