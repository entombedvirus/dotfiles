return {
	'stevearc/dressing.nvim',
	dependencies = {
		'nvim-telescope/telescope.nvim',
	},
	config = function()
		require('dressing').setup({
			input = {
				insert_only = true,
				get_config = function(opts)
					if opts.kind == 'dap_args' then
						return vim.tbl_extend("keep", opts, {
							min_width = 0.35,
						})
					end
				end
			},
			select = {
				-- Priority list of preferred vim.select implementations
				backend = { "telescope", "builtin" },

				-- Options for telescope selector
				telescope = require('telescope.themes').get_dropdown(),
			},
		})
	end,
}
