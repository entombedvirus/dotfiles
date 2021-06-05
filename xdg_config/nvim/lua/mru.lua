local has_tele, telescope = pcall(require, 'telescope')
if not has_tele then
    print('You need to install telescope')
    return
end

local pickers = require('telescope.pickers')
local actions = require('telescope.actions')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')

local state_file = os.getenv('HOME') .. '/.cache/nvim_mru'
local pwd = os.getenv('PWD')

local M = {}

function M.mru_picker(opts)
  pickers.new(opts, {
    prompt_title = 'MRU',
    finder = finders.new_oneshot_job({
            '/bin/bash',
            '-c',
            string.format('cat %s | sed "s@^%s/@mru @"; rg --files', state_file, pwd),
    }, {}),
    sorter = telescope.extensions.fzf.native_fzf_sorter(),
    -- sorter = sorters.get_fuzzy_file(),
    attach_mappings = function(_, map)
      -- Map "<cr>" in insert mode to the function, actions.set_command_line
      map('i', '<cr>', actions.set_command_line)

      -- If the return value of `attach_mappings` is true, then the other
      -- default mappings are still applies.
      --
      -- Return false if you don't want any other mappings applied.
      --
      -- A return value _must_ be returned. It is an error to not return anything.
      return true
    end,
  }):find()
end

return M
