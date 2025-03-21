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
            "go",
		},
	    highlight = {
            enable = true,
		    additional_vim_regex_highlighting = false,
        },
	    auto_install = true,
	},
}
