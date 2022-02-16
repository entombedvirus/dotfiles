local utils = require('telescope.utils')
local pickers = require('telescope.pickers')
local config = require('telescope.config')
local action_set = require('telescope.actions.set')
local action_state = require('telescope.actions.state')
local themes = require('telescope.themes')
local finders = require('telescope.finders')

local max_mru_entries = 200

local make_mru_set = function(paths)
    local set = {}
    for _, p in ipairs(paths) do
        set[p] = true
    end
    return set
end

local custom_entry_maker = function(path_list)
    local set = make_mru_set(path_list)
    return function(line)
        local filename = line
        return {
            value = filename,
            ordinal = filename,
            filename = filename,
            display = function(_)
                local hl_group
                local display = filename
                if set[filename] then
                    -- add a prefix to items from the mru list to tell them apart quickly
                    display = "mru " .. display
                end
                -- prefix with a devicon if there is one available and add the
                -- appropriate syntax highlight group to it
                display, hl_group = utils.transform_devicons(filename, display, false)
                if hl_group then
                    return display, { { {1, 3}, hl_group } }
                else
                    return display
                end
            end,
        }
    end
end

local MruPicker = {}
-- `obj.foo` desugars to `getmetatable(obj).__index.foo`. So set
-- MruPicker.__index to itself so that we end up doing getmetatable(obj).foo
MruPicker.__index = MruPicker

function MruPicker:cache_file()
    -- memoize
    if self.cache_file_path ~= nil then
        return self.cache_file_path
    end
    local cleaned_cwd = string.gsub(self.cwd, "/", "-");
    local dir = vim.fn.stdpath('cache') .. '/custom-mru/proj' .. cleaned_cwd;
    vim.fn.mkdir(dir, "p")
    self.cache_file_path = dir .. '/mru.txt'
    if vim.fn.filereadable(self.cache_file_path) == 0 then
        vim.fn.writefile({}, self.cache_file_path)
    end
    return self.cache_file_path
end

function MruPicker:find_command()
    local mru_cmd = 'cat ' .. self:cache_file()
    local rg_options = '--files'
    if self.rg_options ~= nil then
        rg_options = self.rg_options
    end
    -- put the output thru awk to dedupe them since entries in mru will appear
    -- twice otherwise
    local dedupe_cmd = "awk '!seen[$0]++'"
    return {'/bin/bash','-c', string.format('(%s; rg %s) | %s', mru_cmd, rg_options, dedupe_cmd)}
end

function MruPicker:finder()
    return finders.new_oneshot_job(self:find_command(), {
        entry_maker = custom_entry_maker(self.path_list),
    })
end

function MruPicker:update_mru_list(new_entry)
    local path_list = self.path_list
    for idx, path in ipairs(path_list) do
        if new_entry == path then
            table.remove(path_list, idx)
        end
    end
    -- since we only read max_mru_entries from the file, the length
    -- of path_list is only ever max max_mru_entries + 1
    table.insert(path_list, 1, new_entry)
    vim.fn.writefile(path_list, self:cache_file())
end

function MruPicker:new(o)
    local obj = setmetatable(o or {}, self)
    obj.cwd = obj.cwd or vim.fn.getcwd()
    obj.path_list = vim.fn.readfile(obj:cache_file(), '', max_mru_entries)
    obj.picker = pickers.new({
        results_title = 'Files',
        finder = obj:finder(),
        sorter = config.values.file_sorter(),
        attach_mappings = function()
            action_set.select:enhance({
                post = function()
                    -- Will run after actions.select_default
                    local entry = action_state.get_selected_entry()
                    obj:update_mru_list(entry.filename)
                end,
            })
            return true
        end,
    }, themes.get_dropdown({
        layout_config = {
            width = 0.6,
        },
    }))
    return obj
end

local M = {}

M.find = function()
    local cwd = vim.fn.getcwd()

    local rg_options
    if cwd == os.getenv('HOME') .. '/cl' then
        -- in the dotfiles repo, we need to see hidden files, but not inside
        -- the .git directory
        rg_options = "--files --hidden --glob '!.git/' --glob '!git/'"
    end

    local p = MruPicker:new {
        cwd = cwd,
        rg_options = rg_options,
    }
    p.picker:find()
end

return M
