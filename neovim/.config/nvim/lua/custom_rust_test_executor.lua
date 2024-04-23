-- modified version of https://github.com/mrcjkb/rustaceanvim/blob/6ddb5268d5aeebabc32e31536eabd4e29ec0df8d/lua/rustaceanvim/executors/termopen.lua

---@type integer | nil
local latest_buf_id = nil

-- scroll target buffer to end (set cursor to last line)
local function scroll_to_end(bufnr)
	vim.api.nvim_buf_call(bufnr, function()
		local target_win = vim.api.nvim_get_current_win()
		vim.api.nvim_set_current_win(target_win)

		local target_line = vim.tbl_count(vim.api.nvim_buf_get_lines(0, 0, -1, true))
		vim.api.nvim_win_set_cursor(target_win, { target_line, 0 })
	end)
end

---@type RustaceanExecutor
local M = {
	execute_command = function(command, args, cwd, _)
		local shell = require('rustaceanvim.shell')
		local ui = require('rustaceanvim.ui')
		local commands = {}
		if cwd then
			table.insert(commands, shell.make_cd_command(cwd))
		end
		table.insert(commands, shell.make_command_from_args(command, args))
		local full_command = shell.chain_commands(commands)

		-- check if a buffer with the latest id is already open, if it is then
		-- delete it and continue
		ui.delete_buf(latest_buf_id)

		-- create the new buffer
		latest_buf_id = vim.api.nvim_create_buf(false, true)

		-- split the window to create a new buffer and set it to our window
		ui.split(true, latest_buf_id)

		-- make the new buffer smaller
		-- ui.resize(false, '-5')

		-- close the buffer when escape is pressed :)
		vim.api.nvim_buf_set_keymap(latest_buf_id, 'n', '<Esc>', ':q<CR>', { noremap = true })

		-- run the command
		vim.fn.termopen(full_command)
		scroll_to_end(latest_buf_id)

		-- when the buffer is closed, set the latest buf id to nil else there are
		-- some edge cases with the id being sit but a buffer not being open
		local function onDetach(_, _)
			latest_buf_id = nil
		end
		vim.api.nvim_buf_attach(latest_buf_id, false, { on_detach = onDetach })
	end,
}

return M
