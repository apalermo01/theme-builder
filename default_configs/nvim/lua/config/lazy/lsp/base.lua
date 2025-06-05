return {
	"neovim/nvim-lspconfig",
	dependencies = {
        "onsails/lspkind.nvim",
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"f3fora/cmp-spell",
		"Dynge/gitmoji.nvim",
	},

	config = function()
		vim.diagnostic.config({
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		-- bigquery
		-- local proj_file = vim.fn.expand("$HOME/.bq_project")
		-- if vim.fn.filereadable(proj_file) ~= 0 then
		-- 	local project_id = vim.fn.trim(vim.fn.readfile(proj_file)[1] or "")
		-- 	if project_id ~= "" then
		-- 		require("lspconfig").bqls.setup({
		-- 			settings = {
		-- 				project_id = project_id,
		-- 			},
		-- 		})
		-- 	end
		-- end
	end,
}
