local nvim_lsp = require('nvim_lsp')
local ncm2 = require('ncm2')
local util = require('vim.lsp.util')
local configs = require('nvim_lsp/configs')
local diagnostic = require('diagnostic')

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
    on_attach=diagnostic.on_attach,
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
    --on_init = ncm2.register_lsp_source
    on_attach=diagnostic.on_attach,
}

--[[ vimscript ]]--
nvim_lsp.vimls.setup{
    --on_init = ncm2.register_lsp_source
}
if not configs.vimls.install_info().is_installed then
    configs.vimls.install()
end

--[[ Bash ]]--
nvim_lsp.bashls.setup{
    --on_init = ncm2.register_lsp_source
}
if not configs.bashls.install_info().is_installed then
    configs.bashls.install()
end

--[[ HTML ]]--
nvim_lsp.html.setup{
    --on_init = ncm2.register_lsp_source
}
if not configs.html.install_info().is_installed then
    configs.html.install()
end

--[[ JSON ]]--
nvim_lsp.jsonls.setup{
    --on_init = ncm2.register_lsp_source
}
if not configs.jsonls.install_info().is_installed then
    configs.jsonls.install()
end

--[[ yaml ]]--
nvim_lsp.yamlls.setup{
    --on_init = ncm2.register_lsp_source
}
if not configs.yamlls.install_info().is_installed then
    configs.yamlls.install()
end

--[[ CSS ]]--
nvim_lsp.cssls.setup{
    --on_init = ncm2.register_lsp_source
}
if not configs.cssls.install_info().is_installed then
    configs.cssls.install()
end

--[[ typescript ]]--
nvim_lsp.tsserver.setup{
    --on_init = ncm2.register_lsp_source
}
if not configs.tsserver.install_info().is_installed then
    configs.tsserver.install()
end

--[[ C / C++ ]]--
nvim_lsp.clangd.setup{
    --on_init = ncm2.register_lsp_source
}

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


local file_types = "go,python,vim,sh,javascript,html,css,c,cpp,typescript"

vim.api.nvim_command [[augroup nvim_lsp_autos]]
vim.api.nvim_command [[autocmd!]]


--[[ highlight current identifier ]]--
vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ autocmd nvim_lsp_autos CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]])
vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ autocmd nvim_lsp_autos CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]])
vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ autocmd nvim_lsp_autos CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])

--[[ mappings that are shared across all supported langs ]]--
vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> gr        <cmd>lua vim.lsp.buf.references()<CR>]])
vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> K         <cmd>lua vim.lsp.buf.hover()<CR>]])
vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> <c-space> <cmd>lua vim.lsp.buf.signature_help()<CR>]])
vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> <c-]>     <cmd>lua vim.lsp.buf.definition()<CR>]])
vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> gd        <cmd>lua vim.lsp.buf.declaration()<CR>]])
vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> gD        <cmd>lua vim.lsp.buf.implementation()<CR>]])
vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> 1gD       <cmd>lua vim.lsp.buf.type_definition()<CR>]])
vim.api.nvim_command([[augroup END]])
