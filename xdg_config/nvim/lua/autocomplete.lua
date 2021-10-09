vim.api.nvim_set_option("completeopt", "menu,menuone,noselect")

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Setup nvim-cmp.
local cmp = require'cmp'

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
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<C-u>'] = cmp.mapping.confirm({ select = true }),
        -- ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        -- ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
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
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
    }
})
