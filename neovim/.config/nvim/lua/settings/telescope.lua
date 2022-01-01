local installed, telescope = pcall(require,'telescope')
if not installed then
    return
end

local actions = require('telescope.actions')

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
        ["<C-q>"] = actions.send_selected_to_qflist,
        ["<C-q><C-f>"] = actions.send_to_qflist,
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
                  path_display = {
                      "shorten",
                  },
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
      ["ui-select"] = {
          require("telescope.themes").get_dropdown {},
      },
  },
}
telescope.load_extension('ui-select')
telescope.load_extension('lsp_handlers')
telescope.load_extension('fzf')

local keymap = vim.api.nvim_set_keymap

local opts = { noremap=true, silent=true }
keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)

keymap("n", "<M-g>", "<cmd>lua require('telescope.builtin').grep_string()<cr>", opts)
keymap("v", "<M-g>", "<esc><cmd>lua require('settings.telescope').grep_selection()<cr>", opts)

-- ctrl-p style MRU
keymap("n", "<leader>fp", "<cmd>FilesMru --tiebreak=end<cr>", opts)
keymap("n", "<c-p>", "<cmd>lua require('custom_mru').find()<cr>", opts)

keymap("n", "<leader>ev", "<cmd>lua require('settings.telescope').find_vim_config()<cr>", opts)

local M = {}

function M.grep_selection()
    local _, srow, scol, _ = unpack(vim.fn.getpos("'<"))
    local _, erow, ecol, _ = unpack(vim.fn.getpos("'>"))
    if srow ~= erow then
        print("cannot search multi line strings")
        return
    end
    local selection = vim.fn.getline("."):sub(scol, ecol)
    require('telescope.builtin').grep_string({search = selection})
end

function M.find_vim_config()
    local config_dir = "~/cl/neovim"
    require("telescope.builtin").find_files {
        prompt_title = "Config",
        results_title = "Config Files Results",
        path_display = { "shorten" },
        search_dirs = {
            config_dir,
        },
        cwd = config_dir,
        hidden = true,
        follow = true,
        -- layout_strategy = "horizontal",
        -- layout_config = { preview_width = 0.65, width = 0.75 },
    }
end

return M
