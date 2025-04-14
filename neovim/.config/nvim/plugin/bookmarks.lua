-- Source: https://www.reddit.com/r/neovim/comments/1js5bg8/harpoon_in_50_lines_of_lua_code_using_native/

local M = {}
M.setup = function()
	for i = 1, 9 do
		local mark_char = string.char(64 + i) -- A=65, B=66, etc.
		vim.keymap.set("n", "<leader>" .. i, function()
			local mark_pos = vim.api.nvim_get_mark(mark_char, {})
			if mark_pos[1] == 0 then
				vim.cmd("normal! gg")
				vim.cmd("mark " .. mark_char)
				vim.cmd("normal! ``") -- Jump back to where we were
				vim.notify("[Bookmarks] mark set", vim.log.levels.INFO)
			else
				vim.cmd("normal! `" .. mark_char) -- Jump to the bookmark
				vim.cmd('normal! `"') -- Jump to the last cursor position before leaving
				vim.notify("[Bookmarks] jumping to " .. mark_pos[4], vim.log.levels.INFO)
			end
		end, { desc = "Toggle mark " .. mark_char })
	end

	-- Delete mark from current buffer
	vim.keymap.set("n", "<leader>md", function()
		for i = 1, 9 do
			local mark_char = string.char(64 + i)
			local mark_pos = vim.api.nvim_get_mark(mark_char, {})

			-- Check if mark is in current buffer
			if mark_pos[1] ~= 0 and vim.api.nvim_get_current_buf() == mark_pos[3] then
				vim.cmd("delmarks " .. mark_char)
				vim.notify("[Bookmarks] mark deleted", vim.log.levels.INFO)
			end
		end
	end, { desc = "Delete mark" })

	-- List bookmarks
	-- use <leader>fm for listing marks
end

M.setup()
