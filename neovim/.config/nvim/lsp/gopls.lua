return {
	cmd       = { 'gopls', '-remote=auto' },
	on_attach = function(client, bufnr)
		local global_on_attach = vim.lsp.config['*'].on_attach
		if (global_on_attach) then
			global_on_attach(client, bufnr)
		end

		local group = vim.api.nvim_create_augroup('my.lsp', {})

		if client:supports_method('textDocument/codeAction') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = group,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.code_action {
						context = {
							diagnostics = {},
							only = {vim.lsp.protocol.CodeActionKind.SourceOrganizeImports}
						},
						apply = true,
					}
				end,
			})
		end
	end,
	settings  = {
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
			hints              = {
				assignVariableTypes    = true,
				functionTypeParameters = true,
				parameterNames         = true,
				rangeVariableTypes     = true,
			},
			--buildFlags = {
			--    -- enable completion is avo files
			--    "-tags=avo",
			--},
		},
	},
}
