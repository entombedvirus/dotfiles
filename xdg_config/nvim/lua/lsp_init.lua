local nvim_lsp = require('nvim_lsp')
local ncm2 = require('ncm2')
local util = require('vim.lsp.util')
local configs = require "nvim_lsp/configs"

--[[ Go ]]--
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
            usePlaceholders    = true,
            completeUnimported = true,
            matcher            = "fuzzy",
            symbolMatcher      = "fuzzy",
        },
    },
}

--[[ Python ]]--
nvim_lsp.pyls.setup{
    on_init = ncm2.register_lsp_source
}

--[[ vimscript ]]--
nvim_lsp.vimls.setup{
    on_init = ncm2.register_lsp_source
}
if not configs.vimls.install_info().is_installed then
    configs.vimls.install()
end

--[[ override default LSP callbacks ]]--

local lsp = require('vim.lsp')
local function open_fzf_preview_qf(err, method, result)
    if not result or vim.tbl_isempty(result) then return end
    util.set_qflist(util.locations_to_items(result))
    -- open popup with quickfix results
    vim.api.nvim_command("FzfPreviewQuickFix")
end

lsp.callbacks["textDocument/references"]     = open_fzf_preview_qf
lsp.callbacks["textDocument/implementation"] = open_fzf_preview_qf


vim.api.nvim_command [[augroup nvim_lsp_autos]]
vim.api.nvim_command [[autocmd!]]

--[[ highlight current identifier ]]--
vim.api.nvim_command [[autocmd CursorHold  *.go,*.py,*.vim lua vim.lsp.buf.document_highlight()]]
vim.api.nvim_command [[autocmd CursorHoldI *.go,*.py,*.vim lua vim.lsp.buf.document_highlight()]]
vim.api.nvim_command [[autocmd CursorMoved *.go,*.py,*.vim lua vim.lsp.buf.clear_references()]]

--[[ mappings that are shared across all supported langs ]]--
vim.api.nvim_command [[autocmd FileType go,python,vim nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>]]
vim.api.nvim_command [[autocmd FileType go,python,vim nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>]]
vim.api.nvim_command [[autocmd FileType go,python,vim nnoremap <silent> <c-i> <cmd>lua vim.lsp.buf.signature_help()<CR>]]
vim.api.nvim_command [[autocmd FileType go,python,vim inoremap <silent> <c-i> <cmd>lua vim.lsp.buf.signature_help()<CR>]]
vim.api.nvim_command [[autocmd FileType go,python,vim nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>]]
vim.api.nvim_command [[autocmd FileType go,python,vim nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>]]
vim.api.nvim_command [[autocmd FileType go,python,vim nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>]]
vim.api.nvim_command [[autocmd FileType go,python,vim nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>]]
vim.api.nvim_command [[augroup END]]
