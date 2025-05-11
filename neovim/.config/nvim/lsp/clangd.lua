return {
	capabilities = {
		-- suppress "warning: multiple different client offset_encodings detected for buffer, this is not supported yet" warning
		-- See: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-997234900
		offsetEncoding = { "utf-16" }
	},
}
