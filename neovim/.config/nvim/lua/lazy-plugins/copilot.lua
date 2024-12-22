return {
	--	{
	--		"CopilotC-Nvim/CopilotChat.nvim",
	--		branch = "canary",
	--		dependencies = {
	--			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
	--			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	--		},
	--		build = "make tiktoken", -- Only on MacOS or Linux
	--		opts = {
	--			debug = true, -- Enable debugging
	--			-- See Configuration section for rest
	--		},
	--		keys = {
	--			{"<leader>ge", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "explain visual selection"}
	--		}
	--		-- See Commands section for default commands if you want to lazy load on them
	--	},
	{
		"zbirenbaum/copilot.lua",
		config = function()
			local opts = {
				panel = { enabled = true },
				suggestion = { enabled = true },
			}
			require('copilot').setup(opts)

			-- hide copilot suggestion page when cmp menu is open
			local ok, cmp = pcall(require, 'cmp')
			if ok then
				cmp.event:on("menu_opened", function()
					vim.b.copilot_suggestion_hidden = true
				end)

				cmp.event:on("menu_closed", function()
					vim.b.copilot_suggestion_hidden = false
				end)
			end
		end,
	},
	{
		-- "yetone/avante.nvim",
		dir = "~/code/avante.nvim",
		event = "VeryLazy",
		lazy = true,
		version = false, -- set this if you want to always pull the latest change
		opts = {
			provider = "claude",
			openai = {
				model = "gpt-4o-mini"
			},
			mappings = {
				---@class AvanteConflictMappings
				diff = {
					ours = "co",
					theirs = "ct",
					all_theirs = "ca",
					both = "cb",
					cursor = "cc",
					next = "]x",
					prev = "[x",
				},
				suggestion = {
					accept = "<M-l>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
				jump = {
					next = "]]",
					prev = "[[",
				},
				submit = {
					normal = "<CR>",
					insert = "<C-s>",
				},
				-- NOTE: The following will be safely set by avante.nvim
				ask = "<leader>aa",
				edit = "<leader>ae",
				refresh = "<leader>ar",
				focus = "<leader>af",
				toggle = {
					default = "<leader>at",
					debug = "<leader>ad",
					hint = "<leader>ah",
					suggestion = "<leader>as",
					repomap = "<leader>aR",
				},
				sidebar = {
					apply_all = "A",
					apply_cursor = "a",
					switch_windows = "<Tab>",
					reverse_switch_windows = "<S-Tab>",
				},
			}
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua",   -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				'MeanderingProgrammer/render-markdown.nvim',
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	}
}
