return {
	'fatih/vim-go',
	enabled = false,
	-- this installs it's own version of gopls; we want mason
	-- managed one
	-- run = ':GoUpdateBinaries',
	config = function()
		vim.cmd("runtime lua/settings/vim-go.vim")
	end,
}
