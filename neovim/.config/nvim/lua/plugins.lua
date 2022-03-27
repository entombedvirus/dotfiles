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
  use 'rbtnn/vim-jumptoline'

  -- Git
  use {
    'lewis6991/gitsigns.nvim',
    config = [[require('settings.gitsigns')]],
  }
  use {
    'tpope/vim-fugitive',
    requires = {'tpope/vim-rhubarb'},
    config = [[vim.cmd("runtime lua/settings/vim-fugitive.vim")]]
  }

  -- Go
  use {
    'fatih/vim-go',
    run = ':GoUpdateBinaries',
    config = [[vim.cmd("runtime lua/settings/vim-go.vim")]]
  }

  -- react / js
  use 'pangloss/vim-javascript'
  use {
    'mxw/vim-jsx',
    config = [[vim.cmd("runtime lua/settings/vim-jsx.vim")]]
  }

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

  use {
      'nvim-lualine/lualine.nvim',
      requires = {
        {'kyazdani42/nvim-web-devicons', opt = true},
        {'arkav/lualine-lsp-progress'},
      },
      config = function()
          require('lualine').setup {
              options = {
                  component_separators = '',
                  section_separators = '',
              },
              sections = {
                 lualine_a = {'mode'},
                 lualine_b = {'branch'},
                 lualine_c = {{'filename', path = 1}, {'lsp_progress'}},
                 lualine_x = {'encoding', 'fileformat', 'filetype'},
                 lualine_y = {'progress'},
                 lualine_z = {'location'},
              },
              inactive_sections = {
                 lualine_a = {},
                 lualine_b = {},
                 lualine_c = {'filename'},
                 lualine_x = {'location'},
                 lualine_y = {},
                 lualine_z = {},
              },
              tabline = {
                 lualine_a = {'tabs', {'"->"', color = "Label"}},
                 lualine_b = {'buffers'},
                 lualine_c = {},
                 lualine_x = {},
                 lualine_y = {},
                 lualine_z = {},
              },
          }
      end
  }

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
  use {
    'justinmk/vim-sneak',
    config = [[vim.cmd("runtime lua/settings/vim-sneak.vim")]]
  }
  use {
    'FooSoft/vim-argwrap',
    config = [[vim.cmd("runtime lua/settings/vim-argwrap.vim")]]
  }
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
  -- use {
  --     'hrsh7th/vim-vsnip',
  --     requires = {
  --         {'rafamadriz/friendly-snippets'},
  --     },
  --     config = [[vim.cmd("runtime lua/settings/vsnip.vim")]]
  -- }

  use {
    'L3MON4D3/LuaSnip',
    config = [[require('settings.luasnip')]],
  }

  -- autocomplete
  use {
      'hrsh7th/nvim-cmp',
      requires = {
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-buffer',
          'saadparwaiz1/cmp_luasnip' ,
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
          'gbrlsnchs/telescope-lsp-handlers.nvim',
      },
      config = [[require('settings.lsp')]]
  }

  use {
      'folke/lsp-trouble.nvim',
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
          require('trouble').setup()
          vim.api.nvim_set_keymap(
            'n',
            '<space>d',
            '<cmd>TroubleToggle document_diagnostics<cr>',
            { noremap = true }
          )
      end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/playground',
    },
    run = ':TSUpdate',
    config = [[require('settings.treesitter')]]
  }

  -- diagnostics
  use 'kyazdani42/nvim-web-devicons'

  -- lua plugin dev
  use 'tjdevries/nlua.nvim'

  -- rust specific
  use 'simrat39/rust-tools.nvim'

  -- debugging
  use {
    'mfussenegger/nvim-dap',
    config = function()
        local spawn_dlv = function(spawn_opts)
            local stdout = vim.loop.new_pipe(false)
            local stderr = vim.loop.new_pipe(false)
            local handle
            local pid_or_err
            local port = 38697
            local opts = vim.tbl_deep_extend("keep", spawn_opts, {
                args = {
                    "dap",
                    "--log",
                    "--log-output", "dap,rpc",
                    "--log-dest", "/tmp/dlv.log",
                    "-l", "127.0.0.1:" .. port,
                },
                stdio = {nil, stdout, stderr},
                detached = true
            })
            handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
                stdout:close()
                stderr:close()
                handle:close()
                if code ~= 0 then
                    print('dlv exited with code', code)
                end
            end)
            assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
            local append_to_repl = function(err, chunk)
                assert(not err, err)
                if chunk then
                    -- tell dap we successfully started the server
                    vim.schedule(function()
                        require('dap.repl').append(chunk)
                    end)
                end
            end
            stdout:read_start(append_to_repl)
            stderr:read_start(append_to_repl)

            return {
                type = "server",
                host = "127.0.0.1",
                port = port,
            }
        end
        local last_user_input
        local dap = require('dap')
        dap.adapters.go_with_args = function(callback, config)
            local on_confirm = function(main_pkg_and_args)
                if not main_pkg_and_args then
                    -- user canceled
                    return
                end
                local it = main_pkg_and_args:gmatch("%S+")
                local main_pkg_path = it()
                local args = {}
                for arg in it do
                    table.insert(args, arg)
                end
                config.args = args
                local resolved_adapter = spawn_dlv({cwd = main_pkg_path})
                vim.defer_fn(function() callback(resolved_adapter) end, 100)
                last_user_input = main_pkg_and_args
            end

            vim.ui.input({
                prompt = 'main package path and args: ',
                default = last_user_input or vim.fn.expand('%:h'),
                kind = 'dap_args',
            }, on_confirm)
        end

        dap.adapters.go_without_args = function(callback)
            local cwd = vim.fn.expand('%:h')
            local resolved_adapter = spawn_dlv({cwd = cwd})
            -- Wait for delve to start
            vim.defer_fn(function() callback(resolved_adapter) end, 100)
        end

        local last_test_at_cursor_state
        dap.adapters.go_test_at_cursor = function(callback, config)
            local test_name, err = require('settings/treesitter').get_cursor_test_name()
            if err and not last_test_at_cursor_state then
                print('get_cursor_test_name failed: ' .. err)
                return
            end

            local cwd = vim.fn.expand('%:h')
            if not test_name then
                test_name = last_test_at_cursor_state.test_name
                cwd = last_test_at_cursor_state.cwd
            end

            config.args = {'-test.run=' .. test_name .. '$'}
            local resolved_adapter = spawn_dlv({cwd = cwd})
            -- Wait for delve to start
            vim.defer_fn(function() callback(resolved_adapter) end, 100)
            last_test_at_cursor_state = {
                test_name = test_name,
                cwd = cwd,
            }
        end

        dap.configurations.go = {
            {
                type = "go_test_at_cursor",
                name = "Debug cursor test",
                request = "launch",
                mode = "test",
                cwd = "${fileDirname}",
                program = "./",
            },
            {
                type = "go_without_args",
                name = "Debug all tests",
                request = "launch",
                mode = "test",
                cwd = "${fileDirname}",
                program = "./",
            },
            {
                type = "go_with_args",
                name = "Debug w/ args",
                request = "launch",
                program = "./",
                prompt_user_for_args = true,
            },
        }
        local opts = {silent = true, noremap = true}
        vim.api.nvim_set_keymap('n', '<leader>dd', "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
        vim.api.nvim_set_keymap('n', '<leader>dc', "<cmd>lua require'dap'.continue()<cr>", opts)
        vim.api.nvim_set_keymap('n', '<leader>dl', "<cmd>lua require'dap'.run_last()<cr>", opts)
        vim.api.nvim_set_keymap('n', '<leader>dn', "<cmd>lua require'dap'.step_over()<cr>", opts)
        vim.api.nvim_set_keymap('n', '<leader>dN', "<cmd>lua require'dap'.step_into()<cr>", opts)
        vim.api.nvim_set_keymap('n', '<leader>dr', "<cmd>lua require'dap'.run_to_cursor()<cr>", opts)
        vim.api.nvim_set_keymap('n', '<leader>dk', "<cmd>lua require('dap.ui.widgets').hover()<cr>", opts)
        vim.api.nvim_set_keymap('n', '<leader>dR', "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
        vim.api.nvim_set_keymap('n', '<leader>dq', "<cmd>lua require'dap'.terminate()<cr>", opts)
    end,
  }

  -- vim.ui enhancements
  use {
    'stevearc/dressing.nvim',
    requires = {
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        require('dressing').setup({
            input = {
                insert_only = true,
                get_config = function(opts)
                    if opts.kind == 'dap_args' then
                        return vim.tbl_extend("keep", opts, {
                            min_width = 0.35,
                        })
                    end
                end
            },
            select = {
                -- Priority list of preferred vim.select implementations
                backend = { "telescope", "builtin" },

                -- Options for telescope selector
                telescope = require('telescope.themes').get_dropdown(),
            },
        })
    end,
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
