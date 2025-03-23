return {
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		keys = {
			{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", "n", desc = "Navigate Left (Tmux)" },
			{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", "n", desc = "Navigate Right (Tmux)" },
			{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", "n", desc = "Navigate Down (Tmux)" },
			{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", "n", desc = "Navigate Up (Tmux)" },
		},
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
        lazy = false,
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
		lazy = false,
	},
	{
		"lewis6991/gitsigns.nvim",
	},
	{
		"ludovicchabant/vim-gutentags",
	},
	{
		"dcampos/cmp-snippy",
	},
	{
		"honza/vim-snippets",
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
		opts = {
			default_mappings = true,
		},
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
