return {
	'pangloss/vim-javascript',
	{
		'mxw/vim-jsx',
		config = function() vim.cmd("runtime lua/settings/vim-jsx.vim") end,
	},
}
