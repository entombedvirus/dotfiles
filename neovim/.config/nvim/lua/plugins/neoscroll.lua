return {
	"karb94/neoscroll.nvim",
	cond = function()
		-- only enable smooth scroll outside of Neovide. neovide
		-- already has smooth scrolling and this plugin messes with
		-- that.
		local uis = vim.api.nvim_list_uis()
		return (not vim.g.neovide) and #uis > 0
	end,
	config = function()
		require('neoscroll').setup()
	end,
}
