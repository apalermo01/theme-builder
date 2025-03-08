return {
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = { file_types = { "markdown", "md" } },
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = {
					width = {
						min = 0,
						max = -1,
					},
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},
	{
		"sudormrfbin/cheatsheet.nvim",
		requires = {
			{ "nvim-telescope/telescope.nvim" },
			{ "nvim-lua.popup.nvim" },
			{ "nvim-lua/plenary.nvim" },
		},
	},
	{
		"rmagatti/goto-preview",
		event = "BufEnter",
		config = true,
		default_mappings = true,
	},
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
		cmd = "WhichKey",
	},
	{
		"lewis6991/gitsigns.nvim",
	},
	{
		"ludovicchabant/vim-gutentags",
	},
	{
		"dcampos/nvim-snippy",
	},
	{
		"dcampos/cmp-snippy",
	},
	{
		"honza/vim-snippets",
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				-- snippet plugin
				"dcampos/nvim-snippy",
				dependencies = "honza/vim-snippets",
				opts = { history = true, updateevents = "TextChanged,TextChangedI" },
			},

			-- autopairing of (){}[] etc
			{
				"windwp/nvim-autopairs",
				opts = {
					fast_wrap = {},
					disable_filetype = { "TelescopePrompt", "vim" },
				},
				config = function(_, opts)
					require("nvim-autopairs").setup(opts)

					-- setup cmp for autopairs
					local cmp_autopairs = require("nvim-autopairs.completion.cmp")
					require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end,
			},

			-- cmp sources plugins
			{
				"dcampos/cmp-snippy",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		opts = {
			fast_wrap = {},
			disable_filetype = { "TelescopePrompt", "vim" },
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)

			-- setup cmp for autopairs
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	{
		"numToStr/FTerm.nvim",
	},
	{
		"windwp/nvim-projectconfig",
	},
	{
		"nvimtools/none-ls.nvim",
	},
	{
		"chentoast/marks.nvim",
	},
	{
		"onsails/lspkind.nvim",
	},
	{
		"folke/trouble.nvim",
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"famiu/bufdelete.nvim",
	},
}


