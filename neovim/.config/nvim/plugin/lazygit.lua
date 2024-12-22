local state = {
	buf = -1,
	win = -1,
	job = nil,
}

local function open_lazygit_window()
	if not vim.fn.executable("lazygit") then
		vim.notify("lazygit is not installed", vim.log.levels.ERROR)
		return
	end

	local width = math.floor(vim.api.nvim_get_option("columns") * 0.90)
	local height = math.floor(vim.api.nvim_get_option("lines") * 0.90)

	-- Calculate centered position
	local row = math.floor((vim.api.nvim_get_option("lines") - height) / 2)
	local col = math.floor((vim.api.nvim_get_option("columns") - width) / 2)

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded"
	}

	if not vim.api.nvim_buf_is_valid(state.buf) then
		state.buf = vim.api.nvim_create_buf(false, true)
	end
	-- Create the floating window
	if vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_hide(state.win)
		state.win = -1
	else
		state.win = vim.api.nvim_open_win(state.buf, true, opts)
		if state.job == nil then
			state.job = vim.fn.termopen("lazygit", {
				on_exit = function()
					vim.api.nvim_win_close(state.win, true)
					state.buf = -1
					state.win = -1
					state.job = nil
				end
			})
		end
		vim.cmd("startinsert")
	end
end

vim.keymap.set("n", "<leader>G", open_lazygit_window, {
	silent = true,
	desc = "Open lazygit window"
})
