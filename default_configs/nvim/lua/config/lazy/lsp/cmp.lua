-- auto complete


-- `/` cmdline setup.
local cmp = require("cmp")
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

return {
	"hrsh7th/nvim-cmp",
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
		local cmp = require("cmp")
        local lspkind = require("lspkind")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},

			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol",
					maxwidth = {
						menu = 50,
						abbr = 50,
					},
					ellipsis_char = "...",
					show_labelDetails = true,
					before = function(entry, vim_item)
						vim_item.menu = entry.source.name
						return vim_item
					end,
				}),
			},

			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<TAB>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-j>"] = cmp.mapping.select_prev_item(cmp_select),
				["<S-TAB>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-k>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				-- ["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-space>"] = cmp.mapping.complete(),
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "render-markdown" },
				{ name = "obsidian" },
				-- { name = 'spell' },
				-- { name = 'gitmoji' },
				{ name = "path" },
			}),
		})
	end,
}
