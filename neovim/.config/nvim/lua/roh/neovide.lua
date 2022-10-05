-- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
vim.g.neovide_transparency = 0.0
vim.g.transparency = 0.9
vim.g.neovide_background_color = '#0f1117' .. vim.fn.printf('%x', vim.fn.float2nr(255 * vim.g.transparency))

vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

vim.g.neovide_input_macos_alt_is_meta = true

vim.opt.guifont = { "Iosevka SS08 Medium", "h18" }
