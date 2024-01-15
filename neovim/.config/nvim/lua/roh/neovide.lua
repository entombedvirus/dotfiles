-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
-- vim.g.neovide_transparency = 0.0
-- vim.g.transparency = 0.95
-- vim.g.neovide_background_color = '#1E1F2F' .. vim.fn.printf('%x', vim.fn.float2nr(255 * vim.g.transparency))

vim.g.neovide_transparency = 0.95
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

vim.g.neovide_scroll_animation_length = 0.100
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_input_macos_alt_is_meta = true
-- no transparency if fullscreen is activated this way
-- vim.g.neovide_fullscreen = true

-- See https://github.com/neovide/neovide/blob/main/website/docs/configuration.md#display
-- Font settings are configured in .config/neovide/config.toml
-- vim.opt.guifont = { "Victor Mono,Iosevka SS08 Light:h16:#e-subpixelantialias" }
vim.opt.linespace = 16;

-- dynamically change scale
local function changeScaleFactor(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

vim.g.neovide_scale_factor = 1.0
vim.keymap.set('n', '<D-=>', function() changeScaleFactor(1.10) end)
vim.keymap.set('n', '<D-->', function() changeScaleFactor(1 / 1.10) end)
vim.keymap.set('n', '<D-0>', function() vim.g.neovide_scale_factor = 1.0 end)

-- Allow clipboard copy paste in neovim
vim.g.neovide_input_use_logo = 1
vim.keymap.set('v', '<D-c>', '"+y', { silent = true })
vim.keymap.set({ 'v', 'n' }, '<D-v>', '"+p', { silent = true })
vim.keymap.set('i', '<D-v>', '<esc>"+pa', { silent = true })
vim.keymap.set('c', '<D-v>', '<c-r>+', { silent = true })
vim.keymap.set('t', '<D-v>', '<c-\\><c-n>"+pa', { silent = true })
