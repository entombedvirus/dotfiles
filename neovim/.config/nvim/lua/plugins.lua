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

local plugins = {
	-- Navigation
	'justinmk/vim-dirvish',
	'rbtnn/vim-jumptoline',

	-- Git
	{
		'lewis6991/gitsigns.nvim',
		config = function()
			require('settings.gitsigns')
		end,
	},
	{
		'tpope/vim-fugitive',
		dependencies = { 'tpope/vim-rhubarb' },
		keys = {
			{ [[<leader>u]], [[:GBrowse!<cr>]], mode = { 'n', 'x' } },
		},
		-- non-lazy needed to get various keymaps
		lazy = false,
	},
	{
		'ldelossa/gh.nvim',
		dependencies = { 'ldelossa/litee.nvim' },
		config = function()
			require('litee.lib').setup()
			require('litee.gh').setup({
				-- deprecated, around for compatability for now.
				jump_mode             = "invoking",
				-- remap the arrow keys to resize any litee.nvim windows.
				map_resize_keys       = false,
				-- do not map any keys inside any gh.nvim buffers.
				disable_keymaps       = false,
				-- the icon set to .
				icon_set              = "default",
				-- any custom icons to .
				icon_set_custom       = nil,
				-- whether to register the @rname and #issue_number omnifunc completion
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
					-- browser. ful particularily for digging into external failed CI
					-- checks.
					goto_web = "gx"
				},
			})
		end,
	},

	-- Go
	{
		'fatih/vim-go',
		-- this installs it's own version of gopls; we want mason
		-- managed one
		-- run = ':GoUpdateBinaries',
		config = function()
			vim.cmd("runtime lua/settings/vim-go.vim")
		end,
	},

	-- react / js
	'pangloss/vim-javascript',
	{
		'mxw/vim-jsx',
		config = function() vim.cmd("runtime lua/settings/vim-jsx.vim") end,
	},

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
	--  {
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
	-- },
	--  {
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
	--         },
	--         vim.cmd("colorscheme kanagawa")
	--     end,
	-- },
	{
		'catppuccin/nvim',
		name = 'catppuccin',
		config = function()
			local catppuccin = require("catppuccin")
			vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
			catppuccin.setup({
				-- Neovide requires transparent_background set to false for color to work correctly
				transparent_background = not vim.g.neovide,
				term_colors = true,
				integrations = {
					lsp_trouble = true,
					vim_sneak = true,
					mason = true,
					treesitter_context = true,
				},
				compile = {
					enabled = true,
					path = vim.fn.stdpath "cache" .. "/catppuccin",
				},
			})

			local sign = vim.fn.sign_define
			sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
			sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
			vim.cmd [[colorscheme catppuccin]]
		end,
	},

	{
		'nvim-lualine/lualine.nvim',
		-- after = 'nightfox.nvim',
		dependencies = {
			{ 'kyazdani42/nvim-web-devicons' },
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
	},

	-- Editing
	'ntpeters/vim-better-whitespace',
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to  `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to  defaults
				surrounds = {
					-- disable inserting control chars when pressing things like backspace while in surround mode
					invalid_key_behavior = {
						add = { "", "" },
					},
					["|"] = {
						add = { "|", "|" },
					}
				},
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
	},
	'tpope/vim-unimpaired',
	'tpope/vim-abolish',
	'tpope/vim-repeat',
	'tpope/vim-commentary',
	'michaeljsmith/vim-indent-object',
	'coderifous/textobj-word-column.vim',
	'AndrewRadev/splitjoin.vim',
	'wellle/targets.vim',
	{
		'justinmk/vim-sneak',
		init = function() vim.cmd("runtime lua/settings/vim-sneak.vim") end,
	},
	{
		'FooSoft/vim-argwrap',
		config = function() vim.cmd("runtime lua/settings/vim-argwrap.vim") end,
	},
	'whiteinge/diffconflicts',
	-- search visual selected contents with '*' and '#'
	'nelstrom/vim-visual-star-search',
	-- multiple cursors
	'mg979/vim-visual-multi',

	-- Jsonnet
	{
		'google/vim-jsonnet',
		init = function()
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
	},

	-- Bazel
	'bazelbuild/vim-ft-bzl',

	-- terminal
	{
		'voldikss/vim-floaterm',
		init = function()
			vim.g.floaterm_keymap_toggle = [[<leader>t]]
			vim.cmd [[highlight link FloatermBorder FloatBorder]]
		end,
	},

	-- testing
	{
		'vim-test/vim-test',
		config = function() vim.cmd("runtime lua/settings/vim-test.vim") end,
	},

	-- fuzzy finding
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/popup.nvim',
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		config = function() require('settings.telescope') end,
	},

	'tami5/sql.nvim',

	{
		'L3MON4D3/LuaSnip',
		config = function() require('settings.luasnip') end,
	},

	-- autocomplete
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'f3fora/cmp-spell',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function() require('settings.nvim_cmp') end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			'neovim/nvim-lspconfig',
		},
		config = function()
			require('settings.lsp')
		end,
	},

	{
		'onsails/lspkind-nvim',
		config = function()
			local lspkind = require("lspkind")
			lspkind.init({
				symbol_map = {
					Copilot = "",
				},
			})
			vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
		end
	},

	-- provides lsp progress notification toasts
	{
		'j-hui/fidget.nvim',
		tag = 'legacy',
		config = function()
			require('fidget').setup({})
		end,
	},

	{
		'folke/lsp-trouble.nvim',
		dependencies = "kyazdani42/nvim-web-devicons",
		config = function()
			require('trouble').setup()
			vim.api.nvim_set_keymap(
				'n',
				'<space>d',
				'<cmd>TroubleToggle document_diagnostics<cr>',
				{ noremap = true }
			)
		end
	},

	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end
	},

	{
		'nvim-treesitter/nvim-treesitter',
		-- build = ':TSUpdateSync',
		config = function() require('settings.treesitter') end,
	},
	{
		'nvim-treesitter/playground',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
	},
	{
		'nvim-treesitter/nvim-treesitter-textobjects',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require 'treesitter-context'.setup {}
		end,
	},
	-- diagnostics
	'kyazdani42/nvim-web-devicons',

	-- rust specific
	{
		"mrcjkb/rustaceanvim",
		ft = { "rust" },
		event = "BufReadPost",
		version = "^3", -- Recommended
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			{
				"lvimuser/lsp-inlayhints.nvim",
				opts = {},
				config = function()
					require("lsp-inlayhints").setup()
					vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
					vim.api.nvim_create_autocmd("LspAttach", {
						group = "LspAttach_inlayhints",
						callback = function(args)
							if not (args.data and args.data.client_id) then
								return
							end

							local bufnr = args.buf
							local client = vim.lsp.get_client_by_id(args.data.client_id)
							require("lsp-inlayhints").on_attach(client, bufnr)
						end,
					})
				end,
			},
		},
	},

	-- debugging
	{
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
			local last_r_input
			local dap = require('dap')
			dap.adapters.go_with_args = function(callback, config)
				local on_confirm = function(main_pkg_and_args)
					if not main_pkg_and_args then
						-- r canceled
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
					last_r_input = main_pkg_and_args
				end

				vim.ui.input({
					prompt = 'main package path and args: ',
					default = last_r_input or vim.fn.expand('%:h'),
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
					prompt_r_for_args = true,
				},
			}

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
	},

	-- vim.ui enhancements
	{
		'stevearc/dressing.nvim',
		dependencies = {
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

		{
			"karb94/neoscroll.nvim",
			cond = function()
				-- only enable smooth scroll outside of Neovide. neovide
				-- already has smooth scrolling and this plugin messes with
				-- that.
				local uis = vim.api.nvim_list_uis()
				return (not vim.g.neovide) and #uis > 0
			end,
			config = function()
				require('neoscroll').setup()
			end,
		},

		'digitaltoad/vim-pug',

		-- better looking folds
		{
			'kevinhwang91/nvim-ufo',
			dependencies = 'kevinhwang91/promise-async',
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
		},
	},
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	-- if packer_bootstrap then
	-- 	require('packer').sync()
	-- end
}

require("lazy").setup(plugins, {})
