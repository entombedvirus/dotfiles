local Path = require('plenary.path')
local utils = require('telescope.utils')
local pickers = require('telescope.pickers')
local config = require('telescope.config')
local action_set = require('telescope.actions.set')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local themes = require('telescope.themes')
local finders = require('telescope.finders')

local max_mru_entries = 200

local M = {}

local mru_cache_file = function()
    local cleaned_cwd = string.gsub(vim.fn.getcwd(), "/", "-");
    local dir = vim.fn.stdpath('cache') .. '/custom-mru/proj' .. cleaned_cwd;
    vim.fn.mkdir(dir, "p")
    local cache_file = dir .. '/mru.txt'
    if vim.fn.filereadable(cache_file) == 0 then
        vim.fn.writefile({}, cache_file)
    end
    return cache_file
end

local find_command = function()
    local mru_cmd = 'cat ' .. mru_cache_file()

    local cwd = vim.fn.expand(vim.fn.getcwd())
    local rg_cmd = 'rg --files'
    if cwd == os.getenv('HOME') .. '/cl' then
        rg_cmd = rg_cmd .. " --hidden --glob '!.git/' --glob '!git/'"
    end
    local dedupe_cmd = "awk '!seen[$0]++'"
    return {'/bin/bash','-c', string.format('(%s; %s) | %s', mru_cmd, rg_cmd, dedupe_cmd)}
end

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
                -- local display = Path:new(filename):make_relative(cwd)
                local display = filename
                if set[filename] then
                    display = "mru " .. display
                end
                -- display = string.sub(line, 1, #prefix) .. display
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

local finder = function(path_list)
    local cmd = find_command()
    return finders.new_oneshot_job(cmd, {
        entry_maker = custom_entry_maker(path_list),
    })
end

local write_updated_mru_list = function(new_entry, path_list)
    for idx, path in ipairs(path_list) do
        if new_entry == path then
            table.remove(path_list, idx)
        end
    end
    table.insert(path_list, 1, new_entry)
    if #path_list > max_mru_entries then
        path_list = table.unpack(path_list, 1, max_mru_entries)
    end
    vim.fn.writefile(path_list, mru_cache_file())
end

M.find = function()
    local path_list = vim.fn.readfile(mru_cache_file(), '', max_mru_entries)
    local picker = pickers.new({
        results_title = 'Files',
        -- Run an external command and show the results in the finder window
        -- finder = finders.new_oneshot_job({bin_file, '--files'}, {
        --     entry_maker = extract_fn_entry_maker(),
        -- }),
        finder = finder(path_list),
        sorter = config.values.file_sorter(),
        attach_mappings = function()
            action_set.select:enhance({
                post = function()
                    -- Will run after actions.select_default
                    local entry = action_state.get_selected_entry()
                    -- utils.get_os_command_output({bin_file, '--update', entry.filename})
                    write_updated_mru_list(entry.filename, path_list)
                end,
            })
            return true
        end,
    }, themes.get_dropdown({
        layout_config = {
            width = 0.6,
        },
    }))
    picker:find()
end

return M
