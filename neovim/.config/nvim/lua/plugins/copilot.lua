return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		keys = {
			{"<leader>ge", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "explain visual selection"}
		}
		-- See Commands section for default commands if you want to lazy load on them
	},
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
	}
}

