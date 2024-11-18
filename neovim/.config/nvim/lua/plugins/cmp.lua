return {
	'hrsh7th/nvim-cmp',
	dependencies = {
		'f3fora/cmp-spell',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-nvim-lua',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'onsails/lspkind-nvim',
		"tailwind-tools",
		{
			"zbirenbaum/copilot-cmp",
			opts = {},
		},
	},
	config = function()
		local cmp = require('cmp')
		vim.api.nvim_set_option("completeopt", "menu,menuone,noselect")
		-- Disabling this for now since enabling spell leads to underlines everywhere and
		-- it is super distracting. Actual LSP diagnostic errors gets buried.
		-- Setting spell (and spelllang) is mandatory to use spellsuggest.
		-- vim.opt.spell = true
		-- vim.opt.spelllang = { 'en_us' }

		-- gives pretty icons in the autocomplete popup
		local lspkind = require('lspkind')
		vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
		local luasnip = require('luasnip')

		local function next_func(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end

		local function prev_func(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end

		cmp.setup({
			completion = {
				autocomplete = false,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			snippet = {
				expand = function(args)
					require 'luasnip'.lsp_expand(args.body)
				end,
			},
			experimental = {
				ghost_text = true,
			},
			formatting = {
				format = lspkind.cmp_format({
					before = require("tailwind-tools.cmp").lspkind_format,
					mode = 'symbol',
					maxwidth = 50,
					ellipsis_char = '...',
					show_labelDetails = true,
					menu = {
						nvim_lua = "[lua]",
						nvim_lsp = "[lsp]",
						luasnip  = "[snip]",
						buffer   = "[buf]",
						spell    = "[spell]",
					},
					symbol_map = {
						Codeium = "",
						Copilot = "",
					},
				}),
			},
			mapping = {
				['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
				['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
				['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
				['<C-e>'] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				['<C-u>'] = cmp.mapping.confirm({ select = true }),
				['<C-j>'] = cmp.mapping(next_func, { 'i', 's' }),
				['<C-k>'] = cmp.mapping(prev_func, { 'i', 's' }),
			},
			sorting = {
				priority_weight = 2,
				comparators = {
					require("copilot_cmp.comparators").prioritize,

					-- Below is the default comparitor list and order for nvim-cmp
					cmp.config.compare.offset,
					-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
			sources = {
				-- order matters: completions show up in priority order
				{ name = "copilot" },
				{ name = 'nvim_lsp' },
				{ name = 'nvim_lua' },
				-- { name = 'buffer' },
				-- { name = 'spell' },
				-- { name = 'luasnip' },
			}
		})
	end,
}
