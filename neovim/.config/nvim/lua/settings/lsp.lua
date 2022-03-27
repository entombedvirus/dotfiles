local lspconfig_installed, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_installed then
    return
end

-- vim.lsp.set_log_level(vim.log.levels.TRACE)

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<c-space>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('i', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
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
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>l', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)

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

    -- if client.resolved_capabilities.code_lens then
    --     vim.api.nvim_exec([[
    --       augroup lsp_code_lens
    --         autocmd!
    --         autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
    --       augroup END
    --     ]], false)
    --     buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.codelens.run()<CR>', opts)
    -- end

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

--[[ Go ]]--
function Goimports(timeout_ms)
    local gopls_client = vim.tbl_filter(function(client)
        return client.name == 'gopls'
    end, vim.lsp.get_active_clients())

    if not gopls_client or not gopls_client[1] then
      vim.notify('GoImports: gopls is not attached to buffer', vim.log.levels.WARN)
      return
    end
    gopls_client = gopls_client[1]

    local function apply_action(action)
        -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
        -- is a CodeAction, it can have either an edit, a command or both. Edits
        -- should be executed first.
        if action.edit or type(action.command) == "table" then
            if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, gopls_client.offset_encoding)
            end
            if type(action.command) == "table" then
                vim.lsp.buf.execute_command(action.command)
            end
        else
            vim.lsp.buf.execute_command(action)
        end
    end

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    local result, err = gopls_client.request_sync("textDocument/codeAction", params, timeout_ms)
    if result then
        for _, actions in pairs(result) do
            for _, action in ipairs(actions) do
                if action.kind == "source.organizeImports" then
                    apply_action(action)
                end
            end
        end
    elseif err then
      vim.notify('GoImports: ' .. err, vim.log.levels.WARN)
    end

    vim.lsp.buf.formatting_sync(nil, timeout_ms)
end

local util = require 'lspconfig.util'

local noop = function()
end

local flags = {
    debounce_text_changes = 250,
    -- debounce_text_changes = 3000,
}

local function build_custom_jsonnet_ls_server()
    local server_name = 'my_jsonnet_ls'
    local server = require "nvim-lsp-installer.server"
    local root_dir = server.get_server_root_path(server_name)
    local std = require "nvim-lsp-installer.installers.std"
    local path = require "nvim-lsp-installer.path"
    local process = require "nvim-lsp-installer.process"
    local context = require "nvim-lsp-installer.installers.context"

    local s = server.Server:new {
        name = server_name,
        root_dir = root_dir,
        homepage = 'https://github.com/entombedvirus/jsonnet-language-server',
        languages = { 'jsonnet', 'libsonnet' },
        installer = {
            std.git_clone('https://github.com/entombedvirus/jsonnet-language-server.git'),
            function(_, callback, ctx)
                process.spawn("go", {
                    args = { "build", "." },
                    cwd = ctx.install_dir,
                    stdio_sink = ctx.stdio_sink,
                }, callback)
            end,
            context.receipt(function(receipt)
                receipt:with_primary_source(receipt.git_remote 'https://github.com/entombedvirus/jsonnet-language-server.git')
            end),
        },
        default_options = {
            cmd = { path.concat { root_dir, "jsonnet-language-server" } },
            -- cmd_env = {
            --     PATH = process.extend_path { root_dir },
            -- },
        },
    }

    local configs = require "lspconfig.configs"
    configs[s.name] = {
        default_config = {
            filetypes = s.languages,
            root_dir = function(fname)
                local util = require 'lspconfig.util'
                return util.root_pattern 'Makefile'(fname) or util.find_git_ancestor(fname)
            end,
            on_new_config = function(new_config, file_root_dir)
                -- common jsonnet library paths
                local function jsonnet_path(parent_dir)
                    local paths = {
                        util.path.join(parent_dir, 'lib'),
                        util.path.join(parent_dir, 'vendor'),
                    }
                    return table.concat(paths, ':')
                end
                new_config.cmd_env = {
                    JSONNET_PATH = jsonnet_path(file_root_dir),
                }
            end,
        },
    }
    return s
end

local setup_server = function(lang)
    local lsp_installer = require'nvim-lsp-installer'

    -- advertise that we have a snippet plugin installed to the default lsp client
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    do
        local ok, cmp = pcall(require, 'cmp_nvim_lsp')
        if ok then
            capabilities = cmp.update_capabilities(capabilities)
        end
    end

    local opts = {
        on_attach    = on_attach,
        capabilities = capabilities,
    }

    if lang == "efm" then
        opts = {
            on_attach    = on_attach,
            flags        = flags,
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
                            formatCommand      = './tools/black --quiet -',
                            formatStdin        = true,
                            lintCommand        = './tools/flake8 --stdin-display-name ${INPUT} -',
                            lintStdin          = true,
                            lintFormats        = {'%f:%l:%c: %m'},
                            lintIgnoreExitCode = true,
                        },
                    },
                }
            }
        }

    elseif lang == "gopls" then
        opts = {
            cmd          = {'gopls', '-remote=auto'},
            on_attach    = on_attach,
            flags        = flags,
            capabilities = capabilities,
            settings     = {
                gopls = {
                    usePlaceholders    = true,
                    completeUnimported = true,
                    -- experimentalDiagnosticsDelay = "0ms",
                    codelenses         = {
                        generate           = false,
                        gc_details         = false,
                        test               = false,
                        tidy               = false,
                        vendor             = false,
                        upgrade_dependency = false,
                    },
                    --buildFlags = {
                        --    -- enable completion is avo files
                        --    "-tags=avo",
                        --},
                    },
                },
                handlers = {
                    -- ["textDocument/publishDiagnostics"] = noop,
                    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                        -- delay update diagnostics
                        update_in_insert = false,
                        virtual_text     = true,
                        underline        = false,
                    }),
                },
        }

    elseif lang == "my_jsonnet_ls" then
        local my_server = build_custom_jsonnet_ls_server()
        local servers = require "nvim-lsp-installer.servers"
        servers.register(my_server)
        opts.settings = {
            ext_vars = {
                gcpProject = 'dummy_gcp_project',
                arbCluster = 'dummy_arb_cluter',
                kubeCluster = 'dummy_cluster',
                namespace = 'dummy_namespace',
                containerProject = 'dummy_container_project',
                registry = 'us.gcr.io/dummy_registry',
            }
        }
    end

    local ok, server = lsp_installer.get_server(lang)
    if not ok then
        print(lang, "is not a known language server")
        return
    end

    if lang == "rust_analyzer" then
        server:on_ready(function ()
            -- See: https://github.com/simrat39/rust-tools.nvim#initial-setup
            -- See: https://github.com/williamboman/nvim-lsp-installer/wiki/Rust
            -- Initialize the LSP via rust-tools instead
            require("rust-tools").setup {
                -- The "server" property provided in rust-tools setup function are the
                -- settings rust-tools will provide to lspconfig during init.            --
                -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
                -- with the user's own settings (opts).
                server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
            }
            server:attach_buffers()
        end)

    elseif lang == "sumneko_lua" then
        server:on_ready(function()
            opts.globals = {
                'P', 'RELOAD'
            }
            local lua_opts = vim.tbl_deep_extend("force", server:get_default_options(), opts)
            local nlua = require('nlua.lsp.nvim')
            nlua.base_directory = util.path.join(server.root_dir, 'extension/server/bin')
            nlua.bin_location = util.path.join(nlua.base_directory, 'lua-language-server')
            nlua.setup(lspconfig, lua_opts)
            -- local runtime_path = vim.split(package.path, ';')
            -- table.insert(runtime_path, "lua/?.lua")
            -- table.insert(runtime_path, "lua/?/init.lua")
            -- lspconfig.sumneko_lua.setup(vim.tbl_deep_extend("force", server:get_default_options(), opts))
            server:attach_buffers()
        end)

    else
        server:on_ready(function()
            server:setup(opts)
        end)
    end

    if not server:is_installed() then
        -- Queue the server to be installed
        server:install()
    end
end

local langs = {
    'bashls',
    'clangd',
    'cssls',
    'dockerls',
    'efm',
    'gopls',
    'grammarly',
    'html',
    'jsonls',
    'my_jsonnet_ls',
    'rust_analyzer',
    'sumneko_lua',
    'tsserver',
    'vimls',
    'yamlls',
}

for _, lang in pairs(langs) do
    setup_server(lang)
end


