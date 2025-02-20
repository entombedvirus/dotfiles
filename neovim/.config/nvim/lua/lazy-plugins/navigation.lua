return {
	{
		'justinmk/vim-dirvish',
		config = function()
			-- remove the <c-p> mapping since it interferes with telescope
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dirvish",
				callback = function()
					-- use pcall to suppress warnings about no such mapping
					pcall(vim.keymap.del, 'n', '<C-p>', { buffer = true })
				end,
				group = vim.api.nvim_create_augroup("dirvish_config", { clear = true })
			})
		end,
	},
	'rbtnn/vim-jumptoline',
}
