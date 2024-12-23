return {
	-- colorschemes
	--  'frankier/neovim-colors-solarized-truecolor-only'
	--  'justinmk/molokai'
	--  'nanotech/jellybeans.vim'
	--  'morhetz/gruvbox'
	--  'romainl/flattened'
	--  'whatyouhide/vim-gotham'
	--  'NLKNguyen/papercolor-theme'
	--  'rakr/vim-one'
	--  'rakr/vim-two-firewatch'
	--  'mhartington/oceanic-next'
	--  'joshdick/onedark.vim'
	--  'KeitaNakamura/neodark.vim'
	--  'neutaaaaan/iosvkem'
	--  'chriskempson/base16-vim'
	--  'ayu-theme/ayu-vim'
	--  'drewtempelmeyer/palenight.vim'
	--  'NieTiger/halcyon-neovim'
	--  { 'embark-theme/vim', as = 'embark' },
	--  'tiagovla/tokyodark.nvim'
	--  'folke/tokyonight.nvim'
	--  'yashguptaz/calvera-dark.nvim'
	{
		'EdenEast/nightfox.nvim',
		config = function()
			local nightfox = require('nightfox')
			nightfox.setup({
				options = {
					transparent = not vim.g.neovide,
					styles = {
						comments  = "italic", -- change style of comments to be italic
						keywords  = "bold,italic", -- change style of keywords to be bold
						functions = "italic", -- styles can be a comma separated list
						strings   = "italic", -- styles can be a comma separated list
					},
					inverse = {
						match_paren = true, -- inverse the highlighting of match_parens
					},
				},
			})
			vim.cmd('colorscheme duskfox')
		end,
	},
	-- {
	-- 	'rebelot/kanagawa.nvim',
	-- 	config = function()
	-- 		require('kanagawa').setup {
	-- 			undercurl            = true, -- enable undercurls
	-- 			commentStyle         = "italic",
	-- 			functionStyle        = "NONE",
	-- 			keywordStyle         = "italic",
	-- 			statementStyle       = "bold",
	-- 			typeStyle            = "italic",
	-- 			variablebuiltinStyle = "italic",
	-- 			specialReturn        = true, -- special highlight for the return keyword
	-- 			specialException     = true, -- special highlight for exception handling keywords
	-- 			transparent          = false, -- do not set background color
	-- 			colors               = {},
	-- 			overrides            = {},
	-- 		}
	-- 		vim.cmd("colorscheme kanagawa")
	-- 	end,
	-- },
	-- {
	-- 	'catppuccin/nvim',
	-- 	name = 'catppuccin',
	-- 	config = function()
	-- 		local catppuccin = require("catppuccin")
	-- 		vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
	-- 		catppuccin.setup({
	-- 			-- Neovide requires transparent_background set to false for color to work correctly
	-- 			transparent_background = not vim.g.neovide,
	-- 			term_colors = true,
	-- 			integrations = {
	-- 				lsp_trouble = true,
	-- 				vim_sneak = true,
	-- 				mason = true,
	-- 				treesitter_context = true,
	-- 			},
	-- 			compile = {
	-- 				enabled = true,
	-- 				path = vim.fn.stdpath "cache" .. "/catppuccin",
	-- 			},
	-- 		})
	--
	-- 		local sign = vim.fn.sign_define
	-- 		sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
	-- 		sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
	-- 		sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
	-- 		vim.cmd [[colorscheme catppuccin]]
	-- 	end,
	-- },
}
