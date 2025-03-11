return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"vim",
			"lua",
			"vimdoc",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"javascript",
			"typescript",
			"tsx",
			"svelte",
			"python",
			"c",
		},
	},
	highlight = { enable = true },
	auto_install = true,
}
