return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/popup.nvim',
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	config = function()
		local telescope = require('telescope')
		local actions = require('telescope.actions')
		local utils = require('telescope.utils')

		telescope.setup {
			defaults = {
				-- show file path above the preview window
				dynamic_preview_title = true,
				path_display = function(opts, path)
					-- local display_path = utils.transform_path({ path_display = { "smart" } }, path)
					local display_path = path
					display_path = display_path:gsub("go/src/mixpanel.com", "§")
					return utils.transform_path({ path_display = { shorten = 3 } }, display_path)
				end,
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
				fzf = {
					fuzzy = false,             -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case",  -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown {},
				},
			},
		}

		telescope.load_extension('fzf')

		local keymap = vim.keymap.set

		local opts = { noremap = true, silent = true }
		keymap("n", "<leader>ff",
			"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>"
			, opts)
		keymap("n", "<leader>fg", function()
			require('telescope.builtin').live_grep({ hidden = true, additional_args = { "--ignore-case" } })
		end, opts)
		keymap("n", "<leader>fb",
			"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
			opts)
		keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)
		keymap("n", "<leader>fm", "<cmd>lua require('telescope.builtin').marks()<cr>", opts)
		keymap("n", "<leader>fq", "<cmd>lua require('telescope.builtin').quickfix()<cr>", opts)

		keymap({ "n", "v" }, "<M-g>", "<cmd>lua require('telescope.builtin').grep_string()<cr>", opts)

		-- ctrl-p style MRU
		keymap("n", "<leader>fp", "<cmd>FilesMru --tiebreak=end<cr>", opts)
		keymap("n", "<c-p>", "<cmd>lua require('custom_mru').find()<cr>", opts)

		local function find_vim_config()
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
		keymap("n", "<leader>ev", find_vim_config, opts)
	end,

}
