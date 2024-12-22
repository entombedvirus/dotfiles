local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = ('  %d '):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, 'MoreMsg' })
	return newVirtText
end

return {
	'kevinhwang91/nvim-ufo',
	event = "VeryLazy",
	dependencies = {
		'kevinhwang91/promise-async',
		"luukvbaal/statuscol.nvim",
	},
	init = function()
		vim.o.fillchars = [[eob: ,fold: ,foldopen:⌄,foldsep: ,foldclose:›]]
		vim.o.foldcolumn = '1'
		vim.wo.foldlevel = 99 -- feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.wo.foldenable = true
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				-- force fold column to have the same bg so it does not stand out
				-- vim.api.nvim_set_hl(0, "FoldColumn", { default = false, bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg })

				-- these are defaults if the colorscheme does not set them
				vim.api.nvim_set_hl(0, "UfoFoldedFg", { default = true, fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg })
				vim.api.nvim_set_hl(0, "UfoFoldedBg", { default = true, bg = vim.api.nvim_get_hl(0, { name = "Folded" }).bg })
				vim.api.nvim_set_hl(0, "UfoPreviewSbar", { default = true, link = "PmenuSbar" })
				vim.api.nvim_set_hl(0, "UfoPreviewThumb", { default = true, link = "PmenuThumb" })
				vim.api.nvim_set_hl(0, "UfoPreviewWinBar", { default = true, link = "UfoFoldedBg" })
				vim.api.nvim_set_hl(0, "UfoPreviewCursorLine", { default = true, link = "Visual" })
				vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { default = true, link = "Comment" })
				vim.api.nvim_set_hl(0, "UfoCursorFoldedLine", { default = true, link = "CursorLine" })
			end,
		})
	end,
	opts = {
		fold_virt_text_handler = handler,
		close_fold_kinds_for_ft = {
			default = { 'imports', 'comment' },
			json = { 'array' },
			c = { 'comment', 'region' }
		},
		-- provider_selector = function()
		-- 	return { "treesitter", "indent" }
		-- end,
	},
}
