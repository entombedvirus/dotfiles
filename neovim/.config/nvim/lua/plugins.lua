-- reload on save
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Navigation
  use 'mileszs/ack.vim'
  use 'justinmk/vim-dirvish'
  -- use 'ludovicchabant/vim-gutentags'
  -- use 'tweekmonster/fzf-filemru'
  -- use 'junegunn/fzf'
  -- use 'junegunn/fzf.vim'
  use 'rbtnn/vim-jumptoline'

  -- Git
  use { 'lewis6991/gitsigns.nvim', config = [[require('settings.gitsigns')]] }
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'

  -- Go
  use { 'fatih/vim-go', run = ':GoUpdateBinaries' }
  use 'majutsushi/tagbar'

  -- react / js
  use 'pangloss/vim-javascript'
  use 'mxw/vim-jsx'

  -- colorschemes
  use 'frankier/neovim-colors-solarized-truecolor-only'
  use 'justinmk/molokai'
  use 'nanotech/jellybeans.vim'
  use 'morhetz/gruvbox'
  use 'romainl/flattened'
  use 'whatyouhide/vim-gotham'
  use 'NLKNguyen/papercolor-theme'
  use 'rakr/vim-one'
  use 'rakr/vim-two-firewatch'
  use 'mhartington/oceanic-next'
  use 'joshdick/onedark.vim'
  use 'KeitaNakamura/neodark.vim'
  use 'neutaaaaan/iosvkem'
  use 'chriskempson/base16-vim'
  use 'ayu-theme/ayu-vim'
  use 'drewtempelmeyer/palenight.vim'
  use 'NieTiger/halcyon-neovim'
  use { 'embark-theme/vim', as = 'embark' }
  use 'tiagovla/tokyodark.nvim'
  use 'folke/tokyonight.nvim'
  use 'yashguptaz/calvera-dark.nvim'
  use 'glepnir/zephyr-nvim'
  use 'EdenEast/nightfox.nvim'
  use 'rebelot/kanagawa.nvim'

  -- lightline
  use 'itchyny/lightline.vim'
  use 'mgee/lightline-bufferline'

  -- Editing
  use 'ntpeters/vim-better-whitespace'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-abolish'
  use 'tpope/vim-repeat'
  use 'tpope/vim-commentary'
  use 'michaeljsmith/vim-indent-object'
  use 'coderifous/textobj-word-column.vim'
  use 'AndrewRadev/splitjoin.vim'
  use 'wellle/targets.vim'
  use 'justinmk/vim-sneak'
  use 'FooSoft/vim-argwrap'
  use 'whiteinge/diffconflicts'
  -- search visual selected contents with '*' and '#'
  use 'nelstrom/vim-visual-star-search'
   -- multiple cursors
  use 'mg979/vim-visual-multi'

  -- Jsonnet
  use 'google/vim-jsonnet'

  -- Bazel
  use 'bazelbuild/vim-ft-bzl'

  -- terminal
  use 'voldikss/vim-floaterm'

  -- testing
  use {
      'vim-test/vim-test',
      config = [[vim.cmd("runtime lua/settings/vim-test.vim")]]
  }

  -- fuzzy finding
  use {
      'nvim-telescope/telescope.nvim',
      requires = {
          'nvim-lua/popup.nvim',
          'nvim-lua/plenary.nvim',
          { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      },
      config = [[require('settings.telescope')]]
  }

  use 'tami5/sql.nvim'

  -- Snippets
  use 'hrsh7th/vim-vsnip'
  use 'rafamadriz/friendly-snippets'

  -- autocomplete
  use {
      'hrsh7th/nvim-cmp',
      requires = {
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-vsnip',
          'hrsh7th/cmp-nvim-lua',
          'f3fora/cmp-spell',
      },
      config = [[require('settings.nvim_cmp')]]
  }

  use {
      'neovim/nvim-lspconfig',
      requires = {
          'williamboman/nvim-lsp-installer',
          'onsails/lspkind-nvim',
          'folke/lsp-trouble.nvim',
          'gbrlsnchs/telescope-lsp-handlers.nvim',
      },
      config = [[require('settings.lsp')]]
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    run = ':TSUpdate',
    config = [[require('settings.treesitter')]]
  }

  -- diagnostics
  use 'kyazdani42/nvim-web-devicons'

  -- lua plugin dev
  use 'folke/lua-dev.nvim'

  -- rust specific
  use 'simrat39/rust-tools.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
