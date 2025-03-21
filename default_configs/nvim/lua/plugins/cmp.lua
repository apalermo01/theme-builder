return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"dcampos/nvim-snippy",
		"onsails/lspkind.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"obsidian.nvim",
		"render-markdown.nvim",
	},
	event = "InsertEnter",
	opts = function()
		local cmp_status, cmp = pcall(require, "cmp")
		local snippy_status, snippy = pcall(require, "snippy")
		local lspkind_status, lspkind = pcall(require, "lspkind")

		if not cmp_status then
			print("ERROR: Could not load cmp")
			return
		end

		if not snippy_status then
			print("ERROR: Could not load snippy")
		end

		if not lspkind_status then
			print("ERROR: Could not load lspkind")
		end

		-- Main setup for nvim-cmp
		cmp.setup({
			snippet = {
				expand = function(args)
					if snippy_status then
						snippy.lsp_expand(args.body)
					end
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "snippy" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "obsidian.nvim" },
				{ name = "render-markdown" },
			}),
			formatting = lspkind_status and {
				format = lspkind.cmp_format({ mode = "symbol_text" }),
			} or nil,
		})

		-- `/` cmdline setup.
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- `:` cmdline setup.
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})
	end,
}
