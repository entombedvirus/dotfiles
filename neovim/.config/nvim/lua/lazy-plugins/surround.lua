return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to  `main` branch for the latest features
	init = function()
		vim.g.nvim_surround_no_mappings = true
	end,
	config = function()
		require("nvim-surround").setup({
			-- Configuration here, or leave empty to  defaults
			surrounds = {
				-- disable inserting control chars when pressing things like backspace while in surround mode
				invalid_key_behavior = {
					add = { "", "" },
				},
				["|"] = {
					add = { "|", "|" },
				}
			},
		})

		vim.keymap.set("i", "<C-s>", "<Plug>(nvim-surround-insert)", {
			desc = "Add a surrounding pair around the cursor (insert mode)",
		})
		vim.keymap.set("i", "<C-s><C-s>", "<Plug>(nvim-surround-insert-line)", {
			desc = "Add a surrounding pair around the cursor, on new lines (insert mode)",
		})
		vim.keymap.set("n", "ys", "<Plug>(nvim-surround-normal)", {
			desc = "Add a surrounding pair around a motion (normal mode)",
		})
		vim.keymap.set("n", "yss", "<Plug>(nvim-surround-normal-cur)", {
			desc = "Add a surrounding pair around the current line (normal mode)",
		})
		vim.keymap.set("n", "yS", "<Plug>(nvim-surround-normal-line)", {
			desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
		})
		vim.keymap.set("n", "ySS", "<Plug>(nvim-surround-normal-cur-line)", {
			desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
		})
		vim.keymap.set("x", "S", "<Plug>(nvim-surround-visual)", {
			desc = "Add a surrounding pair around a visual selection",
		})
		vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)", {
			desc = "Add a surrounding pair around a visual selection, on new lines",
		})
		vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", {
			desc = "Delete a surrounding pair",
		})
		vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", {
			desc = "Change a surrounding pair",
		})

		-- emulate a shortcut from vim-surround
		vim.keymap.set("i", "<C-s><C-s><C-]>", "<C-s><C-s>}", { remap = true, silent = true })
	end
}
