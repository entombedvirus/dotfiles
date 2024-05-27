local function get_cursor_test_name()
	local ok, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')
	if not ok then return nil, 'nvim-treesitter.ts_utils is not available' end

	local current_node = ts_utils.get_node_at_cursor()
	if not current_node then return nil, 'no current node' end

	local expr = current_node
	while expr do
		if expr:type() == 'function_declaration' then
			break
		end
		expr = expr:parent()
	end
	if not expr then return nil, 'no expr' end

	local name_node = expr:field('name')
	if not name_node then return nil, 'no field named name' end

	local name_text = ts_utils.get_node_text(name_node[1])
	if not name_text then return nil, 'get_node_text failed' end

	name_text = name_text[1]
	if not name_text then return nil, 'name_text get failed' end

	if not name_text:find('^Test') then return nil, 'not a test function' end
	return name_text
end

return {
	{
		'nvim-treesitter/nvim-treesitter',
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					'bash',
					'c',
					'cpp',
					'css',
					'go',
					'html',
					'javascript',
					'json',
					'lua',
					'python',
					'rust',
					'typescript',
					'terraform',
					'yaml',
				},           -- one of 'all', 'language', or a list of languages
				highlight = {
					enable = true, -- false will disable the whole extension
					disable = { 'python' }, -- list of language that will be disabled
					additional_vim_regex_highlighting = false,
					--disable = { 'go' },               -- list of language that will be disabled
				},
				incremental_selection = {
					enable = true,
					disable = { 'markdown' }, -- LSP hover popup uses this and we can't hijack <cr> there
					--disable = { 'cpp', 'lua' },
					keymaps = {         -- mappings for incremental selection (visual mappings)
						init_selection = "<cr>", -- maps in normal mode to init the node/scope selection
						node_incremental = "<cr>", -- increment to the upper named parent
						scope_incremental = "<c-<cr>>", -- increment to the upper scope (as defined in locals.scm)
						node_decremental = "<space><cr>", -- decrement to the previous node
					}
				},
				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]F"] = "@function.outer",
							["]A"] = "@parameter.inner",
						},
						goto_previous_start = {
							["[F"] = "@function.outer",
							["[A"] = "@parameter.inner",
						},
					},
				},
				textsubjects = {
					enable = true,
					prev_selection = ',', -- (Optional) keymap to select the previous selection
					keymaps = {
						['.'] = 'textsubjects-smart',
						[';'] = 'textsubjects-container-outer',
						['i;'] = { 'textsubjects-container-inner', desc = "Select inside containers (classes, functions, etc.)" },
					},
				},
			})
		end,
	},
	{
		'RRethy/nvim-treesitter-textsubjects',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
		enabled = false,
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require 'treesitter-context'.setup {
				max_lines = 5,
			}
		end,
	},

}
