local nvim_lsp = require('nvim_lsp')
local ncm2 = require('ncm2')
local util = require('vim.lsp.util')

nvim_lsp.gopls.setup{
    cmd = {
        "gopls",

        -- share the gopls instance if there is one already
        "-remote=auto",

        --[[ debug options ]]--
        --"-logfile=auto",
        --"-debug=:0",
        --"-remote.debug=:0",
        --"-rpc.trace",
    },
    on_init = ncm2.register_lsp_source,
    settings = {
        gopls = {
            usePlaceholders = true,
            completeUnimported = true,
            matcher = "fuzzy",
            symbolMatcher = "fuzzy",
        },
    },
}

nvim_lsp.pyls.setup{
    on_init = ncm2.register_lsp_source
}

--[[ override default LSP callbacks ]]--

local lsp = require('vim.lsp')
lsp.callbacks["textDocument/references"] = function(_, _, result)
    if not result then return end
    util.set_qflist(util.locations_to_items(result))
    -- open popup with quickfix results
    vim.api.nvim_command("FzfPreviewQuickFix")
end
