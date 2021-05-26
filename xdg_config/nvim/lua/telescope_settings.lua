local actions = require('telescope.actions')

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
      },
    },
  },
  extensions = {
      lsp_handlers = {
          code_action = {
              telescope = require('telescope.themes').get_dropdown({}),
          },
      },
      fzf = {
          fuzzy = false,                   -- false will only do exact matching
          override_generic_sorter = true,  -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
      },
      frecency = {
          -- show_scores = false,
          -- show_unindexed = true,
          -- ignore_patterns = {"*.git/*", "*/tmp/*"},
          workspaces = {
              ["analytics"]    = os.getenv('HOME') .. "/analytics",
          },
      },
  },
}
telescope.load_extension('lsp_handlers')
telescope.load_extension('fzf')
telescope.load_extension('frecency')

local keymap = vim.api.nvim_set_keymap

local opts = { noremap=true, silent=true }
keymap("n", "<c-p>", "<cmd>lua require('telescope.builtin').find_files()<cr>", opts)
keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", opts)
keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)
keymap("n", "<leader>ff", "<cmd>lua require('telescope').extensions.frecency.frecency()<cr>", opts)
