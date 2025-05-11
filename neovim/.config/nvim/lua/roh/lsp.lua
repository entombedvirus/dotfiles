-- @param client vim.lsp.Client
-- @param bufnr integer
local function on_attach(client, bufnr)
	-- TODO: move to rust.vim
	if client.name == 'rust-analyzer' then
		client.server_capabilities.semanticTokensProvider = nil
	end

	-- Auto-format ("lint") on save.
	-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
	if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting') then
		vim.api.nvim_create_autocmd('BufWritePre', {
			group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
			buffer = bufnr,
			callback = function()
				-- local file_types = {
				-- 	python = true,
				-- 	rust = true,
				-- 	lua = true,
				-- 	go = true,
				-- 	jsonnet = true,
				-- 	terraform = true,
				-- 	c = true,
				-- 	typescriptreact = "efm",
				-- 	typescript = "efm",
				-- }
				-- local current_buf = vim.bo[opts.buf].filetype
				-- if not file_types[current_buf] then
				-- 	return
				-- end
				-- if type(file_types[current_buf]) == "string" and client.name ~= file_types[current_buf] then
				-- 	return
				-- end
				vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
			end,
		})
	end

	-- Mappings.
	local opts = { noremap = true, silent = true, buffer = bufnr }
	local special_mappings = {
		lsp_definitions = vim.lsp.buf.definition,
		lsp_implementations = vim.lsp.buf.implementation,
		lsp_type_definitions = vim.lsp.buf.type_definition,
		lsp_references = vim.lsp.buf.references,
		lsp_document_symbols = vim.lsp.buf.document_symbol,
	}
	do
		local has_telescope, builtin = pcall(require, 'telescope.builtin')
		if has_telescope then
			local telescope_opts = {
				lsp_definitions = { fname_width = 0.3 },
				lsp_references = { fname_width = 0.3 },
				lsp_type_definitions = { fname_width = 0.3 },
				lsp_implementations = { fname_width = 0.3 },
				lsp_document_symbols = require('telescope.themes').get_dropdown()
			}
			for func_name in pairs(special_mappings) do
				special_mappings[func_name] = function()
					builtin[func_name](telescope_opts[func_name])
				end
			end
		end
	end

	vim.keymap.set('n', '<c-]>', special_mappings.lsp_definitions, opts)
	vim.keymap.set('n', 'gD', special_mappings.lsp_implementations, opts)
	vim.keymap.set('n', '<space>D', special_mappings.lsp_type_definitions, opts)
	vim.keymap.set('n', 'gr', special_mappings.lsp_references, opts)
	vim.keymap.set('n', '<localleader>gd', special_mappings.lsp_document_symbols, opts)

	vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<c-space>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('i', '<c-y>', vim.lsp.buf.signature_help, opts)

	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
		opts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
	vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
	vim.keymap.set('n', '<space>l', vim.diagnostic.setloclist, opts)
	vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format({ timeout_ms = 10000 }) end, opts)

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		local lsp_highlight_autos = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
		vim.api.nvim_create_autocmd('CursorHold', {
			group = lsp_highlight_autos,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd('CursorMoved', {
			group = lsp_highlight_autos,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	-- start with inlay hints enabled, but turn then off while in insert mode to prevent random cursor jumps
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true)
		local grp = vim.api.nvim_create_augroup('lsp_inlay_hints_group', { clear = true })
		vim.api.nvim_create_autocmd('InsertEnter', {
			group = grp,
			buffer = bufnr,
			callback = function()
				vim.lsp.inlay_hint.enable(false)
			end,
		})
		vim.api.nvim_create_autocmd('InsertLeave', {
			group = grp,
			buffer = bufnr,
			callback = function()
				vim.lsp.inlay_hint.enable(true)
			end,
		})
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
do
	-- autocomplete
	local ok, cmp = pcall(require, 'cmp_nvim_lsp')
	if ok then
		capabilities = vim.tbl_deep_extend("force", capabilities, cmp.default_capabilities())
	end

	-- folds
	if pcall(require, 'ufo') then
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true
		}
	end
end

vim.diagnostic.config({
	-- delay update diagnostics
	update_in_insert = false,
	underline        = true,
	virtual_text     = false,
	virtual_lines    = true,
})

-- local flags = {
-- 	debounce_text_changes = 250,
-- }

vim.lsp.config('*', {
	on_attach    = on_attach,
	capabilities = capabilities,
	-- flags        = flags,
})

vim.lsp.enable {
	"lua_ls",
	"efm",
	"gopls",
	"clangd",

	-- enable these after the config refactor is done
	-- "graphql",
	-- "relay_lsp",

	-- these are not enabled because they are started by other plugins
	-- 'rust-analyzer',
	-- 'ts_ls',
	-- 'tailwindcss'
}
