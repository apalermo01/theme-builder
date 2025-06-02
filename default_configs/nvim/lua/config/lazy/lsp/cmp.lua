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

			preselect = "None",

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
				["$"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["+"] = cmp.mapping.select_next_item(cmp_select),
				["<C-k>"] = cmp.mapping.scroll_docs(-4),
				["<C-j>"] = cmp.mapping.scroll_docs(4),
				["<C-e>"] = cmp.mapping.abort(),
				["<C-o>"] = cmp.mapping.open_docs(),
				["<TAB>"] = cmp.mapping.select_next_item(cmp_select),
				["<S-TAB>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm(),

				-- fn1+h/j/k/l mapped to arrow keys
				-- fn1+y is mapped to >
				-- also map > to confirm so I don't have to move to ctrl
				[">"] = cmp.mapping.confirm({ select = true }),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-space>"] = cmp.mapping.complete(),
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "render-markdown" },
				{ name = "obsidian" },
				{ name = "spell" },
				-- { name = 'gitmoji' },
				{ name = "path" },
			}),
		})

		-- local api = vim.api
		-- local lsp_util = vim.lsp.util
		--
		-- local help_lines = {
		-- 	"Cmp mappings:",
		-- 	"<C-p> • prev item",
		-- 	"<C-n> • next item",
		-- 	"<C-k>/<C-j> • scroll docs",
		-- 	"<C-space> • trigger complete",
		-- 	"<C-y> • confirm ",
		-- 	"<C-e> • abort   ",
		-- 	"<C-o> • open docs",
		-- }
		--
		-- local help_buf = api.nvim_create_buf(false, true)
		-- api.nvim_buf_set_option(help_buf, "bufhidden", "hide")
		-- api.nvim_buf_set_lines(help_buf, 0, -1, false, help_lines)
		--
		-- local help_win
		-- local close_timer
		--
		-- cmp.event:on("menu_opened", function()
		-- 	vim.schedule(function()
		-- 		if close_timer then
		-- 			close_timer:stop()
		-- 			close_timer = nil
		-- 		end
		--
		-- 		if help_win and api.nvim_win_is_valid(help_win) then
		-- 			return
		-- 		end
		--
		-- 		local width = 0
		-- 		local height = #help_lines
		--
		-- 		for _, line in ipairs(help_lines) do
		-- 			width = math.max(width, #line)
		-- 		end
		--
		-- 		local row = 0
		-- 		local col = vim.o.columns - width
		--
		-- 		vim.notify("making cmp window. row = " .. row .. " col = " .. col, vim.log.levels.WARN)
		-- 		-- open the window
		--               help_win = api.nvim_open_win(help_buf, false, {
		--                   relative = 'editor',
		--                   row = row,
		--                   col = col,
		--                   width = width,
		--                   height = height,
		--                   style = 'minimal',
		--                   border = 'rounded',
		--               })
		-- 		-- help_win = lsp_util.open_floating_preview(help_lines, "plaintext", {
		-- 		-- 	relative = "editor",
		-- 		-- 	row = row,
		-- 		-- 	col = col,
		-- 		-- 	width = width,
		-- 		-- 	height = height,
		-- 		-- 	style = "minimal",
		-- 		-- 	border = "rounded",
		-- 		-- })
		-- 	end)
		-- end)
		--
		-- cmp.event:on("menu_closed", function()
		-- 	if help_win and api.nvim_win_is_valid(help_win) then
		-- 		close_timer = vim.defer_fn(function()
		-- 			if help_win and api.nvim_win_is_valid(help_win) then
		-- 				api.nvim_win_close(help_win, true)
		-- 				help_win = nil
		-- 			end
		-- 		end, 10000)
		-- 	end
		-- end)
	end,
}
