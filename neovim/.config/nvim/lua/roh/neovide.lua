-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
vim.g.neovide_transparency = 0.0
vim.g.transparency = 0.95
vim.g.neovide_background_color = '#0f1117' .. vim.fn.printf('%x', vim.fn.float2nr(255 * vim.g.transparency))

vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_fullscreen = true


-- See https://github.com/neovide/neovide/blob/main/website/docs/configuration.md#display
vim.opt.guifont = { "Iosevka SS08 Light:h18:#e-subpixelantialias:#h-full" }

-- dynamically change scale
local function changeScaleFactor(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

vim.g.neovide_scale_factor = 1.0
vim.keymap.set('n', '<D-=>', function() changeScaleFactor(1.25) end)
vim.keymap.set('n', '<D-->', function() changeScaleFactor(1 / 1.25) end)
