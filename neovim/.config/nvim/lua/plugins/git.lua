return {
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add          = { text = '+' },
				change       = { text = '~' },
				delete       = { text = '-' },
				topdelete    = { text = '?' },
				changedelete = { text = '~' },
			},
			numhl = false,
			linehl = false,
			on_attach = function(bufnr)
				vim.api.nvim_buf_set_keymap(bufnr, 'n', ']c',
					"&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
					{ expr = true })
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '[c',
					"&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
					{ expr = true })

				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hs', '<cmd>lua require"gitsigns".stage_hunk()<CR>', {})
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hu', '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
					{})
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hr', '<cmd>lua require"gitsigns".reset_hunk()<CR>', {})
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hR', '<cmd>lua require"gitsigns".reset_buffer()<CR>', {})
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hp', '<cmd>lua require"gitsigns".preview_hunk()<CR>', {})
				vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line()<CR>', {})

				-- Text objects
				vim.api.nvim_buf_set_keymap(bufnr, 'o', 'ih', ':<C-U>lua require"gitsigns".select_hunk()<CR>', {})
				vim.api.nvim_buf_set_keymap(bufnr, 'x', 'ih', ':<C-U>lua require"gitsigns".select_hunk()<CR>', {})
			end,
			watch_gitdir = {
				interval = 1000
			},
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default

		},
	},
	{
		'tpope/vim-fugitive',
		dependencies = { 'tpope/vim-rhubarb' },
		keys = {
			{ [[<leader>u]], [[:GBrowse!<cr>]], mode = { 'n', 'x' } },
		},
		-- non-lazy needed to get various keymaps
		lazy = false,
	},
}
