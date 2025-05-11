local prettier = {
	formatCommand = '~/work/sierra/web/node_modules/.bin/prettier --stdin-filepath ${INPUT}',
	formatStdin   = true,
}

return {
	cmd          = { "efm-langserver", "-logfile=/tmp/efm.log", "-loglevel=5" },
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
	},
	filetypes    = {
		"go",
		"python",
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
		"svelte",
		"astro",
	},
	settings     = {
		rootMarkers = { "package.json", "pyproject.toml", ".git/" },
		languages = {
			python = {
				{
					formatCommand = 'black --line-length 100 --quiet -',
					formatStdin = true,
					lintCommand = 'mypy --show-column-numbers',
					lintFormats = {
						'%f:%l:%c: %trror: %m',
						'%f:%l:%c: %tarning: %m',
						'%f:%l:%c: %tote: %m',
					}
				},
			},
			typescript = {
				prettier,
			},
			typescriptreact = {
				prettier,
			},
			go = {
				{
					lintCommand =
					"bin/golangci-lint-sierra run --new-from-rev=HEAD --out-format=line-number --print-issued-lines=false | tee -a /tmp/gls.log",
					lintIgnoreExitCode = true,
					lintStdin = true, -- this disables efm from passing the file name as arg
					lintFormats = { '%f:%l:%c: %m' },
				},
			},
		},
	}
}
