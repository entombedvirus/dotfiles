local action_set = require('telescope.actions.set')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local config = require('telescope.config')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local Path = require('plenary.path')
local pickers = require('telescope.pickers')
local themes = require('telescope.themes')
local utils = require('telescope.utils')



local telescope = require('telescope')
telescope.setup{
  defaults = {
    mappings = {
      -- To disable a keymap, put [map] = false
      -- You can perform as many actions in a row as you like
      -- ["<cr>"] = actions.select_default + actions.center + my_cool_custom_action,
      -- See: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/actions/init.lua
      i = {
        ["<esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<cr>"] = actions.select_default + actions.center,
      },
    },
  },
  extensions = {
      lsp_handlers = {
          code_action = {
              telescope = require('telescope.themes').get_dropdown({}),
          },
          symbol = {
              telescope = require('telescope.themes').get_dropdown {
                  path_display = {
                      "hidden",
                  },
              },
          },
          location = {
              telescope = {
                  shorten_path = false,
                  tail_path = false,
                  hide_filename = false,
              },
          },
      },
      fzf = {
          fuzzy = false,                   -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
      },
      -- frecency = {
      --     -- show_scores = false,
      --     -- show_unindexed = true,
      --     -- ignore_patterns = {"*.git/*", "*/tmp/*"},
      --     workspaces = {
      --         ["analytics"]    = os.getenv('HOME') .. "/analytics",
      --     },
      -- },
  },
}
telescope.load_extension('lsp_handlers')
telescope.load_extension('fzf')
-- telescope.load_extension('frecency')

local keymap = vim.api.nvim_set_keymap

local opts = { noremap=true, silent=true }
keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)

keymap("n", "<M-g>", "<cmd>lua require('telescope.builtin').grep_string()<cr>", opts)
keymap("v", "<M-g>", "<esc><cmd>lua require('telescope_settings').grep_selection()<cr>", opts)

-- ctrl-p style MRU
keymap("n", "<leader>fp", "<cmd>FilesMru --tiebreak=end<cr>", opts)
keymap("n", "<c-p>", "<cmd>lua require('telescope_settings').custom_mru()<cr>", opts)

return {
    grep_selection = function()
        local _, srow, scol, _ = unpack(vim.fn.getpos("'<"))
        local _, erow, ecol, _ = unpack(vim.fn.getpos("'>"))
        if srow ~= erow then
            print("cannot search multi line strings")
            return
        end
        local selection = vim.fn.getline("."):sub(scol, ecol)
        require('telescope.builtin').grep_string({search = selection})
    end,

    custom_mru = function()
        -- TODO: stop relying on this bin file in another random plugin
        local bin_file = os.getenv('HOME') ..'/.nvim/plugged/fzf-filemru/bin/filemru.sh'

        local extract_fn_entry_maker = function()
            local cwd = vim.fn.expand(opts.cwd or vim.fn.getcwd())
            local prefix = "mru "

            -- line sample: "mru go/src/mixpanel.com/discovery/discovery.go"
            return function(line)
                local filename = string.sub(line, #prefix + 1)
                return {
                    value = filename,
                    ordinal = filename,
                    filename = filename,
                    display = function(_)
                        local hl_group
                        local display = Path:new(filename):make_relative(cwd)
                        display = string.sub(line, 1, #prefix) .. display
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

        local picker = pickers.new({
            results_title = 'Files',
            -- Run an external command and show the results in the finder window
            finder = finders.new_oneshot_job({bin_file, '--files'}, {
                entry_maker = extract_fn_entry_maker(),
            }),
            sorter = config.values.file_sorter(),
            attach_mappings = function()
                 action_set.select:enhance({
                     post = function()
                         -- Will run after actions.select_default
                         local entry = action_state.get_selected_entry()
                         utils.get_os_command_output({bin_file, '--update', entry.filename})
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
    end,
}
