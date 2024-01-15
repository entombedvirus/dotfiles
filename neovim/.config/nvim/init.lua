require('roh.globals')

-- Turn off builtin plugins I do not use.
require 'roh.disable_builtin'

-- global editor settings
require 'roh.editor'

-- neovide specific settings
require 'roh.neovide'

-- load  plugins and  their configs
-- local ok, msg = pcall(require, 'plugins')
-- if not ok then
-- 	vim.notify('plugins: ' .. msg)
-- 	return
-- end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {})
