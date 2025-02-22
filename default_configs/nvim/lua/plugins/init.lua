local plugins = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"neanias/everforest-nvim",
		priority = 1000,
		lazy = false,
		version = false,
	},
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
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"javascript",
				"typescript",
				"tsx",
				"svelte",
				"python",
				"c",
			},
		},
		highlight = { enable = true },
		auto_install = true,
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
			},
		},
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
		"startup-nvim/startup.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
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
		"corcalli/nvim-colorizer.lua",
	},
	{
		"epwalsh/obsidian.nvim",
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"famiu/bufdelete.nvim",
	},
}


require('lazy').setup(plugins)
