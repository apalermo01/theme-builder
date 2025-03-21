return {
    'MeanderingProgrammer/render-markdown.nvim',
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		file_types = { "markdown", "md" },
		preset = "obsidian",
		heading = {
			enabled = true,
			width = "block",
			borer = true,
		},
		checkbox = {
			custom = {
				todo = { raw = "[-]", rendered = "󰥔", highlight = "RenderMarkdownTodo" },
				not_done = { raw = "[d]", rendered = "", highlight = "RednerMarkdownWarn" },
			},
		},

		dash = {
			enabled = true,
		},
        completions = { lsp = { enabled = true } },
	},
}
