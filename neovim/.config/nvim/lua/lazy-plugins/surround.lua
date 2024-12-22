return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to  `main` branch for the latest features
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
			keymaps = {
				insert = "<C-s>",
				insert_line = "<C-s><C-s>",
				normal = "ys",
				normal_cur = "yss",
				normal_line = "yS",
				normal_cur_line = "ySS",
				visual = "S",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
			},
		})
		-- emulate a shortcut from vim-surround
		vim.keymap.set("i", "<C-s><C-s><C-]>", "<C-s><C-s>}", { remap = true, silent = true })
	end
}
