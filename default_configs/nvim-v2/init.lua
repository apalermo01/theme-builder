-- Lazy installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- Leader key
vim.g.mapleader = ","

-----------------------------
-- Plugins ------------------
-----------------------------
require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "christoomey/vim-tmux-navigator", lazy = false },
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
			require("nvim-tree").setup({})
		end,
	},
	{ "nvim-tree/nvim-web-devicons", opts = {} },
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
	{ "lewis6991/gitsigns.nvim" },
    { "ludovicchabant/vim-gutentags" },
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
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
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
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
		config = function()
			require("startup").setup()
		end,
	},

	{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
})

-----------------------------
-- Settings -----------------
-----------------------------

-- General
local set = vim.opt
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
set.number = true
set.rnu = true
set.wrap = false
set.showcmd = true
set.showmode = true
set.compatible = false
set.syntax = "on"
set.wildmenu = true
set.termguicolors = true

vim.cmd([[set path+=**]])
vim.cmd([[set complete+=k]])
vim.cmd([[filetype plugin on]])
vim.cmd([[setlocal spell spelllang=en_us]])

-- UI
set.so = 7
vim.o.cursorlineopt = "both"
vim.o.termguicolors = true
vim.cmd.colorscheme("catppuccin")

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

-----------------------------
-- Key Mappings -------------
-----------------------------

local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

-- Newlines above and below
vim.cmd([[ nnoremap oo o<Esc>k ]])
vim.cmd([[ nnoremap OO O<Esc>j ]])

-- Clear search highlights with Esc
vim.cmd([[ nnoremap <esc> :noh<return><esc> ]])

-- tabs
vim.cmd([[ nnoremap <leader>tn :tabnew<cr> ]])
vim.cmd([[ nnoremap <leader>t<leader> :tabnext ]])
vim.cmd([[ nnoremap <leader>tm :tabmove ]])
vim.cmd([[ nnoremap <leader>tc :tabclose ]])
vim.cmd([[ nnoremap <leader>to :tabonly ]])

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

--------------------------------------
-- Plugin configurations -------------
--------------------------------------

-- bufferline
require("bufferline").setup({
	options = {
		numbers = "ordinal", -- or "buffer_id" for buffer numbers
		close_command = "bdelete! %d",
		right_mouse_command = "bdelete! %d",
		offsets = {
			{ filetype = "NvimTree", text = "File Explorer", text_align = "center" },
		},
		separator_style = "slant", -- or "thin" for a minimal look
		show_buffer_close_icons = true,
		show_close_icon = false,
		diagnostics = "nvim_lsp",
	},
})

map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<return>", { silent = true })
map("n", "<Tab>", "<cmd>BufferLineCycleNext<return>", { silent = true })
map("n", "<leader>x", "<cmd>BufferLinePickClose<CR>")

-- catppuccin
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- cheatsheet
require("cheatsheet").setup({
	bundled_cheatsheets = {
		enabled = { "default" },
		disabled = { "nerd-fonts" },
	},
})

map("n", "<leader>?", "<cmd>Cheatsheet<cr>")

-- conform
map("n", "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

-- lualine
require("lualine").setup({})

-- markdown rendering
require("render-markdown").setup({
	preset = "obsidian",
	heading = {
		enabled = true,
	},

	checkbox = {
		custom = {
			todo = { raw = "[-]", rendered = "󰥔", highlight = "RenderMarkdownTodo" },
			not_done = { raw = "[d]", rendered = "", highlight = "RednerMarkdownWarn" },
		},
	},
})

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- startup screen
require("startup").setup({ theme = "dashboard" })

-- Telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "telescope find all files" }
)

-- Tmux navigation
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })

-----------
--- LSP ---
-----------
require("mason").setup()
require("mason-lspconfig").setup()
-- require("lspconfig").setup()

-- Goto preview
map("n", "<leader>gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>")
map("n", "<leader>gP", "<cmd>lua require('goto-preview').close_all_win()<CR>")

--------------------------------
--- Other events / functions ---
--------------------------------
-- https://github.com/creativenull/dotfiles/blob/9ae60de4f926436d5682406a5b801a3768bbc765/config/nvim/init.lua#L70-L86
-- From vim defaults.vim
-- ---
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
-- vim.api.nvim_create_autocmd('BufReadPost', {
--   group = vim.g.user.event,
--   callback = function(args)
--     local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
--     local not_commit = vim.b[args.buf].filetype ~= 'commit'
--
--     if valid_line and not_commit then
--       vim.cmd([[normal! g`"]])
--     end
--   end,
-- })
