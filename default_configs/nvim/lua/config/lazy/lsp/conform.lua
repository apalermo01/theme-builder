-- formatting

map("n", "<leader>fm", function()
    require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			nix = { "nixfmt" },
			sql = { "sqlfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },
			sh = { "shfmt" },
			md = { "mdformat" },
			markdown = { "mdformat" },
			yaml = { "yamlfix" },
			yml = { "yamlfix" },
		},
	},
}
