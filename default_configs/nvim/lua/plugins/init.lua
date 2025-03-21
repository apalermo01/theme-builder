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
		keys = {
			{ "<C-n>", "<cmd>NvimTreeToggle<CR>", "n", desc = "Toggle NvimTree" },
			{ "<leader>e", "<cmd>NvimTreeFocus<CR>", "n", desc = "Focus NvimTree" },
		},
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
		keys = {
			"<leader>?",
			"<cmd>Cheatsheet<CR>",
			"n",
			desc = "open cheatsheet",
		},
	},
	{
		"rmagatti/goto-preview",
		event = "BufEnter",
		config = true,
		default_mappings = true,
		keys = {
			{
				"gpd",
				"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
				"n",
				desc = "Goto Preview Definition",
			},
			{
				"gpt",
				"<cmd>lua require('goto-preview').goto_preview_type_declaration()<CR>",
				"n",
				desc = "Goto Preview Type Declaration",
			},
			{
				"gpi",
				"<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
				"n",
				desc = "Goto Preview Implementation",
			},
			{
				"gpD",
				"<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
				"n",
				desc = "Goto Preview Declaration",
			},
			{ "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", "n", desc = "Close All Goto Previews" },
			{
				"gpr",
				"<cmd>lua require('goto-preview').goto_preview_references()<CR>",
				"n",
				desc = "Goto Preview References",
			},
		},
	},
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	{
		"folke/which-key.nvim",
		lazy = false,
		keys = {
			{ "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
			{ "<leader>wK", "<cmd>WhichKey <CR>", "n", desc = "WhichKey All Keymaps" },
			{
				"<leader>wk",
				function()
					vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
				end,
				"n",
				desc = "WhichKey Query Lookup",
			},
		},
		cmd = "WhichKey",
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
		keys = {

			{ "<leader>ft", "<cmd>lua require('FTerm').toggle()<cr>", "n", desc = "Toggle FTerm" },
			{
				"<leader>ft",
				"<C-\\><C-n><cmd>lua require('FTerm').toggle()<cr>",
				"t",
				desc = "Toggle FTerm (Terminal)",
			},
			{ "<Esc>", "<C-\\><C-n><cmd>lua require('FTerm').exit()<cr>", "t", desc = "Exit FTerm" },
		},
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
		keys = {
			{ "<leader>fw", "<cmd>Telescope live_grep<CR>", "n", desc = "Live Grep (Telescope)" },
			{ "<leader>fbu", "<cmd>Telescope buffers<CR>", "n", desc = "Find Buffers (Telescope)" },
			{ "<leader>fh", "<cmd>Telescope help_tags<CR>", "n", desc = "Find Help Tags (Telescope)" },
			{ "<leader>ma", "<cmd>Telescope marks<CR>", "n", desc = "Find Marks (Telescope)" },
			{ "<leader>fo", "<cmd>Telescope oldfiles<CR>", "n", desc = "Find Old Files (Telescope)" },
			{
				"<leader>fz",
				"<cmd>Telescope current_buffer_fuzzy_find<CR>",
				"n",
				desc = "Fuzzy Find in Buffer (Telescope)",
			},
			{ "<leader>cm", "<cmd>Telescope git_commits<CR>", "n", desc = "Find Git Commits (Telescope)" },
			{ "<leader>gt", "<cmd>Telescope git_status<CR>", "n", desc = "Find Git Status (Telescope)" },
			{ "<leader>pt", "<cmd>Telescope terms<CR>", "n", desc = "Pick Hidden Term (Telescope)" },
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", "n", desc = "Find Files (Telescope)" },
			{
				"<leader>fa",
				"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
				"n",
				desc = "Find All Files (Telescope)",
			},
			{ "<leader>fbr", "<cmd>Telescope file_browser<cr>", "n", desc = "File Browser (Telescope)" },
			{
				"<leader>ds",
				"<cmd>Telescope lsp_document_symbols<cr>",
				"n",
				desc = "Find Document Symbols (Telescope)",
			},
		},
	},
	{
		"famiu/bufdelete.nvim",
	},
}
