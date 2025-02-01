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
})
-----------------------------
-- AutoCmds -----------------
-----------------------------

vim.cmd([[
augroup FileTypeSettings
    autocmd!
    autocmd BufEnter * lua if vim.bo.filetype == 'python' then PythonSettings() end
    autocmd BufEnter * lua if vim.bo.filetype == 'markdown' then MarkdownSettings() end
augroup end
]])

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
vim.cmd([[set spell spelllang=en_us]])
vim.cmd([[set guifont=JetBrainsMono\ Nerd\ Font\ Mono]])

-- UI
set.so = 7
vim.o.cursorlineopt = "both"
vim.o.termguicolors = true
vim.cmd.colorscheme("catppuccin")

local border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- filetype specific settings
function PythonSettings()
	vim.bo.tabstop = 4
	vim.bo.shiftwidth = 4
	vim.cmd([[set tw=120]])
end

function MarkdownSettings()
	vim.cmd([[set tw=80]])
end
-----------------------------
-- Key Mappings -------------
-----------------------------

local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

-- Newlines above and below
vim.cmd([[ nnoremap oo o<Esc>k ]])
vim.cmd([[ nnoremap OO O<Esc>j ]])

-- tabs
vim.cmd([[ nnoremap <leader>tn :tabnew<cr> ]])
vim.cmd([[ nnoremap <leader>t<leader> :tabnext ]])
vim.cmd([[ nnoremap <leader>tm :tabmove ]])
vim.cmd([[ nnoremap <leader>tc :tabclose ]])
vim.cmd([[ nnoremap <leader>to :tabonly ]])

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- use escape to clear highlights or close open windows
function CloseFloatingOrClearHighlight()
	local floating_wins = 0
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			floating_wins = floating_wins + 1
			vim.api.nvim_win_close(win, false)
		end
	end

	if floating_wins == 0 then
		vim.cmd("noh")
	end
end

map("n", "<Esc>", CloseFloatingOrClearHighlight, { noremap = true, silent = true })

--------------------------------------
-- Plugin configurations -------------
--------------------------------------

-- bufferline
require("bufferline").setup({
	options = {
		numbers = "buffer_id", -- or "buffer_id" for buffer numbers
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

-- cmp

local cmp_status, cmp = pcall(require, "cmp")
local snippy_status, snippy = pcall(require, "snippy")
local lspkind = require("lspkind")

if not snippy_status then
	print("ERROR: could not load snippy")
end
if cmp_status then
	cmp.setup({
		snippet = {
			expand = function(args)
				snippy.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
			["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
			["<C-e>"] = cmp.mapping.abort(), -- close completion window
			["<CR>"] = cmp.mapping.confirm({ select = false }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" }, -- LSP
			{ name = "snippy" }, -- snippets
			{ name = "buffer" }, -- text within the current buffer
			{ name = "path" }, -- file system paths
		}),
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol_text",
			}),
		},
	})
else
	print("ERROR: could not load cmp")
end

-- conform
map("n", "<leader>fm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

-- FTerm
map("n", "<leader>ft", "<cmd>lua require('FTerm').toggle()<cr>")
map("t", "<leader>ft", "<C-\\><C-n><cmd>lua require('FTerm').toggle()<cr>")
map("t", "<Esc>", "<C-\\><C-n><cmd>lua require('FTerm').exit()<cr>")

-- Goto preview
map("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
map("n", "gpt", "<cmd>lua require('goto-preview').goto_preview_type_declaration()<CR>")
map("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
map("n", "gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>")
map("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>")
map("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>")

--lspkind

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

-- marks
require("marks").setup({
	default_mappings = true,
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

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}
local servers = { "html", "cssls", "clangd", "pyright", "ts_ls" }
for _, lsp in ipairs(servers) do
	require("lspconfig")[lsp].setup({ handlers = handlers })
end

----------------------------------
--- Plugins that depend on lsp ---
----------------------------------
-- trouble (diagnostics)
require("trouble").setup({
	cmd = "Trouble",
})

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")


--------------------------------
--- Other events / functions ---
--------------------------------
-- https://stackoverflow.com/questions/774560/in-vim-how-do-i-get-a-file-to-open-at-the-same-line-number-i-closed-it-at-last
vim.cmd([[
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif
]])

-- project config
require("nvim-projectconfig").setup({
	project_dir = "~/.config/projects-config",
})
