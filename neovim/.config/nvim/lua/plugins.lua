local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
	-- stale packer_compiled.lua files can interfere with testing bootstrap code
	pcall(fn.system, { 'rm', '-f', fn.stdpath('config') .. '/plugin/packer_compiled.lua' })
	vim.cmd [[packadd packer.nvim]]
end

-- reload on save
local packer_group = vim.api.nvim_create_augroup('PackerUserRoh', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
	command = 'source <afile> | PackerCompile',
	group = packer_group,
	-- add the HOME prefix so it won't catch fugitive:/// style paths
	pattern = { os.getenv('HOME') .. '/*/plugins.lua' },
})

local ok, packer = pcall(require, 'packer')
if not ok then
	error('packer install failed')
end

packer.init {
	display = {
		open_fn = function()
			return require("packer.util").float { border = "single" }
		end,
		prompt_border = "single",
	},
	git = {
		clone_timeout = 600,
	},
	auto_clean = true,
	compile_on_sync = false,
}

packer.startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Navigation
	use 'justinmk/vim-dirvish'
	use 'rbtnn/vim-jumptoline'

	-- Git
	use {
		'lewis6991/gitsigns.nvim',
		config = [[require('settings.gitsigns')]],
	}
	use {
		'tpope/vim-fugitive',
		requires = { 'tpope/vim-rhubarb' },
		config = [[vim.cmd("runtime lua/settings/vim-fugitive.vim")]]
	}
	use {
		'ldelossa/gh.nvim',
		requires = { { 'ldelossa/litee.nvim' } },
		config = function()
			require('litee.lib').setup()
			require('litee.gh').setup({
				-- deprecated, around for compatability for now.
				jump_mode             = "invoking",
				-- remap the arrow keys to resize any litee.nvim windows.
				map_resize_keys       = false,
				-- do not map any keys inside any gh.nvim buffers.
				disable_keymaps       = false,
				-- the icon set to use.
				icon_set              = "default",
				-- any custom icons to use.
				icon_set_custom       = nil,
				-- whether to register the @username and #issue_number omnifunc completion
				-- in buffers which start with .git/
				git_buffer_completion = true,
				-- defines keymaps in gh.nvim buffers.
				keymaps               = {
					-- when inside a gh.nvim panel, this key will open a node if it has
					-- any futher functionality. for example, hitting <CR> on a commit node
					-- will open the commit's changed files in a new gh.nvim panel.
					open = "<CR>",
					-- when inside a gh.nvim panel, expand a collapsed node
					expand = "zo",
					-- when inside a gh.nvim panel, collpased and expanded node
					collapse = "zc",
					-- when cursor is over a "#1234" formatted issue or PR, open its details
					-- and comments in a new tab.
					goto_issue = "gd",
					-- show any details about a node, typically, this reveals commit messages
					-- and submitted review bodys.
					details = "d",
					-- inside a convo buffer, submit a comment
					submit_comment = "<C-s>",
					-- inside a convo buffer, when your cursor is ontop of a comment, open
					-- up a set of actions that can be performed.
					actions = "<C-a>",
					-- inside a thread convo buffer, resolve the thread.
					resolve_thread = "<C-r>",
					-- inside a gh.nvim panel, if possible, open the node's web URL in your
					-- browser. useful particularily for digging into external failed CI
					-- checks.
					goto_web = "gx"
				}
			})
		end,
	}

	-- Go
	use {
		'fatih/vim-go',
		-- this installs it's own version of gopls; we want mason
		-- managed one
		-- run = ':GoUpdateBinaries',
		config = [[vim.cmd("runtime lua/settings/vim-go.vim")]]
	}

	-- react / js
	use 'pangloss/vim-javascript'
	use {
		'mxw/vim-jsx',
		config = [[vim.cmd("runtime lua/settings/vim-jsx.vim")]]
	}

	-- colorschemes
	-- use 'frankier/neovim-colors-solarized-truecolor-only'
	-- use 'justinmk/molokai'
	-- use 'nanotech/jellybeans.vim'
	-- use 'morhetz/gruvbox'
	-- use 'romainl/flattened'
	-- use 'whatyouhide/vim-gotham'
	-- use 'NLKNguyen/papercolor-theme'
	-- use 'rakr/vim-one'
	-- use 'rakr/vim-two-firewatch'
	-- use 'mhartington/oceanic-next'
	-- use 'joshdick/onedark.vim'
	-- use 'KeitaNakamura/neodark.vim'
	-- use 'neutaaaaan/iosvkem'
	-- use 'chriskempson/base16-vim'
	-- use 'ayu-theme/ayu-vim'
	-- use 'drewtempelmeyer/palenight.vim'
	-- use 'NieTiger/halcyon-neovim'
	-- use { 'embark-theme/vim', as = 'embark' }
	-- use 'tiagovla/tokyodark.nvim'
	-- use 'folke/tokyonight.nvim'
	-- use 'yashguptaz/calvera-dark.nvim'
	-- use {
	-- 	'EdenEast/nightfox.nvim',
	-- 	config = function()
	-- 		local nightfox = require('nightfox')
	-- 		nightfox.setup({
	-- 			options = {
	-- 				transparent = false,
	-- 				styles = {
	-- 					comments  = "italic", -- change style of comments to be italic
	-- 					keywords  = "bold,italic", -- change style of keywords to be bold
	-- 					functions = "italic", -- styles can be a comma separated list
	-- 					strings   = "italic", -- styles can be a comma separated list
	-- 				},
	-- 				inverse = {
	-- 					match_paren = true, -- inverse the highlighting of match_parens
	-- 				},
	-- 			},
	-- 		})
	-- 		vim.cmd('colorscheme duskfox')
	-- 	end,
	-- }
	-- use {
	--     'rebelot/kanagawa.nvim',
	--     config = function()
	--         require('kanagawa').setup {
	--             undercurl            = true, -- enable undercurls
	--             commentStyle         = "italic",
	--             functionStyle        = "NONE",
	--             keywordStyle         = "italic",
	--             statementStyle       = "bold",
	--             typeStyle            = "italic",
	--             variablebuiltinStyle = "italic",
	--             specialReturn        = true, -- special highlight for the return keyword
	--             specialException     = true, -- special highlight for exception handling keywords
	--             transparent          = false, -- do not set background color
	--             colors               = {},
	--             overrides            = {},
	--         }
	--         vim.cmd("colorscheme kanagawa")
	--     end,
	-- }
	use {
		'catppuccin/nvim',
		as = 'catppuccin',
		config = function()
			local catppuccin = require("catppuccin")
			vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
			catppuccin.setup({
				transparent_background = true,
				term_colors = true,
				integrations = {
					lsp_trouble = true,
					vim_sneak = true,
				},
				compile = {
					enabled = true,
					path = vim.fn.stdpath "cache" .. "/catppuccin",
				},
			})
			vim.cmd [[colorscheme catppuccin]]
		end,
	}

	use {
		'nvim-lualine/lualine.nvim',
		-- after = 'nightfox.nvim',
		requires = {
			{ 'kyazdani42/nvim-web-devicons', opt = true },
		},
		config = function()
			require('lualine').setup {
				options = {
					component_separators = '',
					section_separators = '',
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch' },
					lualine_c = { { 'filename', path = 1 }, },
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { 'filename', path = 1 } },
					lualine_x = { 'location' },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {
					lualine_a = { 'tabs', { '"->"', color = "Label" } },
					lualine_b = { 'buffers' },
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
	use {
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
				keymaps = {
					insert = "<C-s>",
					insert_line = "<C-s><C-s>",
					normal = "ys",
					normal_cur = "yss",
					normal_line = "yS",
					normal_cur_line = "ySS",
					visual = "S",
					visual_line = "gS",
					delete = "ds",
					change = "cs",
				},
			})
			-- emulate a shortcut from vim-surround
			vim.keymap.set("i", "<C-s><C-s><C-]>", "<C-s><C-s>}", { remap = true, silent = true })
		end
	}
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
	use {
		'google/vim-jsonnet',
		config = function()
			-- autofmt messes with jsonnet-fmt
			vim.g.jsonnet_fmt_on_save = 0
			local group = vim.api.nvim_create_augroup('jsonnet-mods', { clear = true })
			-- vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'},{
			vim.api.nvim_create_autocmd('FileType', {
				group = group,
				pattern = { 'jsonnet' },
				callback = function()
					-- don't leave hard tabs on jsonnet files
					vim.opt_local.expandtab = true
				end,
			})
		end,
	}

	-- Bazel
	use 'bazelbuild/vim-ft-bzl'

	-- terminal
	use {
		'voldikss/vim-floaterm',
		config = function()
			vim.g.floaterm_keymap_toggle = [[<leader>t]]
			vim.cmd [[highlight link FloatermBorder FloatBorder]]
		end,
	}

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

	use {
		'L3MON4D3/LuaSnip',
		config = [[require('settings.luasnip')]],
	}

	-- autocomplete
	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'f3fora/cmp-spell',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function() require('settings.nvim_cmp') end,
	}
	use {
		"williamboman/mason.nvim",
		requires = {
			"williamboman/mason-lspconfig.nvim",
			'neovim/nvim-lspconfig',
		},
		config = function()
			require('settings.lsp')
		end,
	}

	use {
		'onsails/lspkind-nvim',
	}

	-- provides lsp progress notification toasts
	use {
		'j-hui/fidget.nvim',
		config = function()
			require('fidget').setup {}
		end,
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
		run = ':TSUpdateSync',
		config = [[require('settings.treesitter')]]
	}
	use {
		'nvim-treesitter/playground',
		requires = {
			'nvim-treesitter/nvim-treesitter',
		},
	}
	use {
		'nvim-treesitter/nvim-treesitter-textobjects',
		requires = {
			'nvim-treesitter/nvim-treesitter',
		},
	}
	use {
		'nvim-treesitter/nvim-treesitter-context',
		requires = {
			'nvim-treesitter/nvim-treesitter',
		},
		config = function()
			require 'treesitter-context'.setup {}
		end,
	}
	-- diagnostics
	use 'kyazdani42/nvim-web-devicons'

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
					stdio = { nil, stdout, stderr },
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
					local resolved_adapter = spawn_dlv({ cwd = main_pkg_path })
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
				local resolved_adapter = spawn_dlv({ cwd = cwd })
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

				config.args = { '-test.run=' .. test_name .. '$' }
				local resolved_adapter = spawn_dlv({ cwd = cwd })
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

			-- Rust / C / C++
			dap.adapters.lldb = {
				type = 'executable',
				command = 'lldb', -- adjust as needed, must be absolute path
				name = 'lldb'
			}
			dap.configurations.cpp = {
				{
					name = 'Launch',
					type = 'lldb',
					request = 'launch',
					program = function()
						return vim.fn.input('Path to executable: ', last_user_input or vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
					args = { 'testdata/2022-09-21.1717197a9589bf41.arb' },

					-- ??
					-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
					--
					--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
					--
					-- Otherwise you might get the following error:
					--
					--    Error on launch: Failed to attach to the target process
					--
					-- But you should be aware of the implications:
					-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
					-- runInTerminal = false,
				},
			}

			-- If you want to use this for Rust and C, add something like this:
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp

			local opts = { silent = true, noremap = true }
			vim.api.nvim_set_keymap('n', '<leader>dd', "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
			vim.api.nvim_set_keymap('n', '<leader>dB',
				"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", opts)
			vim.api.nvim_set_keymap('n', '<leader>ddl',
				"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", opts)
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

		use {
			"karb94/neoscroll.nvim",
			cond = function()
				-- only enable smooth scroll outside of Neovide. neovide
				-- already has smooth scrolling and this plugin messes with
				-- that.
				local uis = vim.api.nvim_list_uis()
				return #uis > 0
			end,
			config = function()
				require('neoscroll').setup()
			end,
		},

		use 'digitaltoad/vim-pug',

		-- better looking folds
		use {
			'kevinhwang91/nvim-ufo',
			requires = 'kevinhwang91/promise-async',
			config = function()
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
				vim.wo.foldcolumn = '0'
				vim.wo.foldlevel = 99 -- feel free to decrease the value
				vim.wo.foldenable = true
				require('ufo').setup {
					fold_virt_text_handler = handler,
				}
			end,
		}
	}
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end)
