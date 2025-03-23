return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {
			"vim",
			"lua",
			"vimdoc",
            "hadolint",
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
            "git_config",
            "gitcommit",
            "git_rebase",
            "gitignore",
            "gitattributes"
		},
	    highlight = {
            enable = true,
		    additional_vim_regex_highlighting = false,
        },
	    auto_install = true,
	},
}
