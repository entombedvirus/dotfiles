vim.api.nvim_set_option("completeopt", "menu,menuone,noselect")


local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Setup nvim-cmp.
local cmp = require'cmp'

-- Setting spell (and spelllang) is mandatory to use spellsuggest.
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

-- gives pretty icons in the autocomplete popup
local lspkind = require('lspkind')

cmp.setup({
    completion = {
        autocomplete = false,
    },
    documentation = {
        border = {'┌', '─', '┐', '│', '┘', '─', '└', '│'},
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    experimental = {
        ghost_text = true,
    },
    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            maxwidth = 50,
            menu = {
                nvim_lua = "[lua]",
                nvim_lsp = "[lsp]",
                vsnip    = "[snip]",
                buffer   = "[buf]",
                spell    = "[spell]",
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
        ['<C-j>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn.call('vsnip#available', {1}) == 1 then
                vim.fn.feedkeys(t '<plug>(vsnip-expand-or-jump)', '')
            else
                fallback()
            end
        end,
        ['<C-k>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn.call('vsnip#available', {1}) == 1 then
                vim.fn.feedkeys(t '<plug>(vsnip-jump-prev)', '')
            else
                fallback()
            end
        end,
    },
    sources = {
        -- order matters: completions show up in priority order
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
        { name = 'spell' },
    }
})
