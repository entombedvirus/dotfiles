return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim"
	},
	build = "make build-oxi",
	opts = {
		default = {
			replace = {
				cmd = "oxi"
			}
    }}
}
