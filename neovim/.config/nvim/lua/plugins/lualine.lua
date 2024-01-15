return {
	'nvim-lualine/lualine.nvim',
	-- after = 'nightfox.nvim',
	dependencies = {
		{ 'kyazdani42/nvim-web-devicons' },
	},
	opts = {
		options = {
			component_separators = '',
			section_separators = '',
		},
		sections = {
			lualine_a = { 'mode' },
			lualine_b = { 'branch' },
			lualine_c = { { 'filename', path = 1 }, },
			lualine_x = { 'encoding', 'fileformat', 'filetype' },
			lualine_y = { 'progress' },
			lualine_z = { 'location' },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { { 'filename', path = 1 } },
			lualine_x = { 'location' },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {
			lualine_a = { 'tabs', { '"->"', color = "Label" } },
			lualine_b = { 'buffers' },
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
	},
}
