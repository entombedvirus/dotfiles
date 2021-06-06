-- require('lspfuzzy').setup {}
require('trouble').setup {}

local lspconfig = require('lspconfig')

local on_init = function(client)
    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
        client.config.flags.debounce_text_changes = 250
    end
end

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
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<localleader>gd', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)

    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>d', '<cmd>LspTroubleDocumentToggle<CR>', opts)
    buf_set_keymap('n', '<space>l', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        vim.api.nvim_exec([[
          augroup lsp_fmt_autos
            autocmd!
            autocmd BufWritePre *.py,*.rs lua vim.lsp.buf.formatting_sync(nil, 10000)
            autocmd BufWritePre *.go lua Goimports(1000)
          augroup END
        ]], false)
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
function Goimports(timeout_ms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    vim.lsp.buf.formatting_sync(nil, timeout_ms)

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result then return end

    local applyAction = function(action)
        -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
        -- is a CodeAction, it can have either an edit, a command or both. Edits
        -- should be executed first.
        if action.edit or type(action.command) == "table" then
            if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit)
            end
            if type(action.command) == "table" then
                vim.lsp.buf.execute_command(action.command)
            end
        else
            vim.lsp.buf.execute_command(action)
        end
    end

    for _, actions in pairs(result) do
        if actions and actions.result and type(actions.result) == "table" then
            for _, action in ipairs(actions.result) do
                if action.kind == "source.organizeImports" then
                    applyAction(action)
                end
            end
        end
    end
end

lspconfig.gopls.setup{
    cmd = {
        "gopls",

        -- share the gopls instance if there is one already
        "-remote=auto",

       --[[ debug options ]]--
       --"-profile.trace=/tmp/gopls.trace.out",
       "-logfile=/tmp/gopls.nvim-lsp.log",
       "-remote.logfile=/tmp/gopls.server.log",
       --"-debug=:0",
       "-remote.debug=:0",
       "-rpc.trace",
    },
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            usePlaceholders    = true,
            completeUnimported = true,
            matcher            = "fuzzy",
            symbolMatcher      = "fuzzy",
            experimentalDiagnosticsDelay = "0ms",
            --codelenses         = {
            --    generate   = false,   -- Don't run `go generate`.
            --    gc_details = true,    -- Show a code lens toggling the display of gc's choices.
            --},
            --buildFlags = {
            --    -- enable completion is avo files
            --    "-tags=avo",
            --},
        },
    },
    handlers = {
        --["textDocument/publishDiagnostics"] = noop,
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            -- delay update diagnostics
            update_in_insert = false,
        }),
    },
}

-- vim.lsp.set_log_level("info")

lspconfig.pyright.setup{
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                extraPaths = {os.getenv('HOME')},
            },
        },
    },
}

lspconfig.efm.setup {
    on_init = on_init,
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        documentFormatting = true,
    },
    filetypes = {"python"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            python = {
                {
                    formatCommand = './tools/black --quiet -',
                    formatStdin = true,
                    lintCommand = './tools/flake8 --stdin-display-name ${INPUT} -',
                    lintStdin = true,
                    lintFormats = {'%f:%l:%c: %m'},
                    lintIgnoreExitCode = true,
                },
            },
        }
    }
}

local function set_diff(a, b)
    local ret = {}
    local bi = {}
    for _,v in pairs(b) do bi[v]=true end
    for _,v in pairs(a) do
        if bi[v] ~= true then
            table.insert(ret, v)
        end
    end
    return ret
end

local function setup_servers(langs)
  local install = require('lspinstall')

  local missing_langs = set_diff(langs, install.installed_servers())
  if next(missing_langs) ~= nil then
      if vim.fn.confirm("Some LSP servers are missing. Install them now?", "&Yes\n&No") == 1 then
          for _, lang in pairs(missing_langs) do
              install.install_server(lang)
          end
      end
  end

  install.setup()
  return set_diff(langs, missing_langs)
end

local langs = setup_servers{
    'bash',
    'cpp',
    'css',
    'dockerfile',
    'html',
    'json',
    'lua',
    'rust',
    'typescript',
    'vim',
    'yaml',
}

for _, lang in pairs(langs) do
    if lang == "lua" then
        local luadev = require("lua-dev").setup({
            library = {
                vimruntime = true, -- runtime path
                types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
                plugins = true, -- installed opt or start plugins in packpath
                -- you can also specify the list of plugins to make available as a workspace library
                -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
            },
            -- add any options here, or leave empty to use the default settings
            lspconfig = {
                on_init = on_init,
                on_attach = on_attach,
                capabilities = capabilities,
            },
        })
        lspconfig.lua.setup(luadev)
    elseif lang == "rust" then
        -- See: https://github.com/simrat39/rust-tools.nvim#initial-setup
        require('rust-tools').setup({
            server = {
                on_init = on_init,
                on_attach = on_attach,
                capabilities = capabilities,
            },
        })
    else
        lspconfig[lang].setup{
            on_init = on_init,
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end
end
