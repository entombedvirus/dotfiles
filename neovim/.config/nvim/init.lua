require('roh.globals')

-- Turn off builtin plugins I do not use.
require 'roh.disable_builtin'

-- global editor settings
require 'roh.editor'

-- load  plugins and  their configs
local ok, msg = pcall(require, 'plugins')
if not ok then
    vim.notify('plugins: ' .. msg)
    return
end
