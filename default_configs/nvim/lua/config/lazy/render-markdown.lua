return {
    'MeanderingProgrammer/render-markdown.nvim',
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		file_types = { "markdown", "md" },
        log_level = 'info',
        -- log_runtime = true,
		preset = "obsidian",
        enabled = true,
		heading = {
			enabled = true,
			width = "block",
			border = true,
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
        render_modes = { 'n', 'c', 't' },

	},
}
