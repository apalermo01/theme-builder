return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = function(bufnr)
				if require("conform").get_formatter_info("ruff_format", bufnr).available then
					return { "ruff_format" }
				else
					return { "isort", "black" }
				end
			end,
            go = { 'gofmt' },
            json = { 'yq' },
            md = { 'mdformat' },
            sql = { 'pg_format' },
            yaml = { 'yq' }

		},
	},

	keys = {
		"<leader>fm",
		function()
			require("conform").format({ lsp_fallback = true })
		end,
		"n",
		desc = "general format file",
	},
}
