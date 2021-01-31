local nvim_lsp = require('lspconfig')
local ncm2 = require('ncm2')
local util = require('vim.lsp.util')
local configs = require('lspconfig/configs')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<c-space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- advertise that we have a snippet plugin installed to the default lsp client
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

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
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            usePlaceholders    = true,
            completeUnimported = true,
            matcher            = "fuzzy",
            symbolMatcher      = "fuzzy",
            codelenses         = {
                generate   = false,   -- Don't run `go generate`.
                gc_details = true,    -- Show a code lens toggling the display of gc's choices.
            },
            buildFlags = {
                -- enable completion is avo files
                "-tags=avo",
            },
        },
    },
}

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = {
    "vimls",
    "bashls",
    "html",
    "jsonls",
    "yamlls",
    "cssls",
    "tsserver",
    "clangd",
}

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

----[[ highlight current identifier ]]--
--vim.api.nvim_command([[autocmd FileType ]] .. cursor_types .. [[ autocmd nvim_lsp_autos CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]])
--vim.api.nvim_command([[autocmd FileType ]] .. cursor_types .. [[ autocmd nvim_lsp_autos CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]])
--vim.api.nvim_command([[autocmd FileType ]] .. cursor_types .. [[ autocmd nvim_lsp_autos CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
--
----[[ mappings that are shared across all supported langs ]]--
--vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> gr        <cmd>lua vim.lsp.buf.references()<CR>]])
--vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> K         <cmd>lua vim.lsp.buf.hover()<CR>]])
--vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> <c-space> <cmd>lua vim.lsp.buf.signature_help()<CR>]])
--vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> <c-]>     <cmd>lua vim.lsp.buf.definition()<CR>]])
--vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> gd        <cmd>lua vim.lsp.buf.declaration()<CR>]])
--vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> gD        <cmd>lua vim.lsp.buf.implementation()<CR>]])
--vim.api.nvim_command([[autocmd FileType ]] .. file_types .. [[ nnoremap <silent> 1gD       <cmd>lua vim.lsp.buf.type_definition()<CR>]])
--vim.api.nvim_command([[augroup END]])
