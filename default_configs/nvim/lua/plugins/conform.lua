return {
	"stevearc/conform.nvim",
	opts = function()
		return {
			formatters_by_ft = {
				lua = { "stylua" },
				python = function(bufnr)
					local conform = require("conform")
					local formatter_info = conform.get_formatter_info("ruff_format", bufnr)

					if formatter_info and formatter_info.available then
						return { "ruff_format" }
					else
						return { "isort", "black" }
					end
				end,
				go = { "gofmt" },
				json = { "yq" },
				md = { "mdformat" },
				sql = { "pg_format" },
				yaml = { "yq" },
			},
		}
	end,
	keys = {
		{
			"<leader>fm",
			function()
				require("conform").format({ lsp_fallback = true })
			end,
			"n",
			desc = "general format file",
		},
	},
}
