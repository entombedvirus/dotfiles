local mod_cache = nil

---@param fname string
---@return string?
local function get_root(fname)
	if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
		local clients = vim.lsp.get_clients { name = 'gopls' }
		if #clients > 0 then
			return clients[#clients].config.root_dir
		end
	end
	return vim.fs.root(fname, { 'go.work', 'go.mod', '.git' })
end

return {
	cmd				= { 'gopls', '-remote=auto' },
	filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		-- see: https://github.com/neovim/nvim-lspconfig/issues/804
		if mod_cache then
			on_dir(get_root(fname))
			return
		end
		local cmd = { 'go', 'env', 'GOMODCACHE' }
		vim.system(cmd, { text = true }, function(output)
			if output.code == 0 then
				if output.stdout then
					mod_cache = vim.trim(output.stdout)
				end
				on_dir(get_root(fname))
			else
				vim.notify(('[gopls] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
			end
		end)
	end,
	on_attach = function(client, bufnr)
		local global_on_attach = vim.lsp.config['*'].on_attach
		if (global_on_attach) then
			global_on_attach(client, bufnr)
		end

		local group = vim.api.nvim_create_augroup('my.lsp', { clear = false })

		if client:supports_method('textDocument/codeAction') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = group,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.code_action {
						context = {
							diagnostics = {},
							only = { vim.lsp.protocol.CodeActionKind.SourceOrganizeImports }
						},
						apply = true,
					}
				end,
			})
		end
	end,
	settings	= {
		gopls = {
			usePlaceholders		 = true,
			completeUnimported = true,
			-- experimentalDiagnosticsDelay = "0ms",
			codelenses				 = {
				generate					 = false,
				gc_details				 = false,
				test							 = false,
				tidy							 = false,
				vendor						 = false,
				upgrade_dependency = false,
			},
			hints							 = {
				assignVariableTypes		 = true,
				functionTypeParameters = true,
				parameterNames				 = true,
				rangeVariableTypes		 = true,
			},
			--buildFlags = {
			--		-- enable completion is avo files
			--		"-tags=avo",
			--},
		},
	},
}
