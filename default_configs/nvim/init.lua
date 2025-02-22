-- Variables
OBSIDIAN_NOTES_DIR = os.getenv("OBSIDIAN_NOTES_DIR") or "/home/alex/Documents/git/notes"
OBSIDIAN_NOTES_SUBDIR = os.getenv("OBSIDIAN_NOTES_SUBDIR") or "0-inbox"
OBSIDIAN_TEMPLATE_FOLDER = os.getenv("OBSIDIAN_TEMPLATE_FOLDER") or "5-templates"

map = vim.keymap.set

-- TODO: mess with the surround plugin
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

require("plugins")
require("ftype_settings")
require("opts")
require("keymaps")
require('config.lualine')
require('config.obsidian')
require('config.startup')

vim.cmd.colorscheme("catppuccin")

-- With the above settings, hitting " " after the markdown file opens toggles ALL folds,
-- so run this to automatically open all folds so that " " (za) has the desired behavior
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.md",
	command = "normal! zR",
})

--------------------------------------
-- Plugin configurations -------------
--------------------------------------

-- treesitter
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
			{ name = "obsidian.nvim" },
			{ name = "render-markdown" },
		}),
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol_text",
			}),
		},
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
else
	print("ERROR: could not load cmp")
end

-- colorizer
require("colorizer").setup({
	filetypes = { "*" },
	DEFAULT_OPTIONS = {
		RGB = true,
		RRGGBB = true,
		names = false,
		RRGGBBAA = true,
		css = true,
		css_fn = true,
	},
})
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

-- markdown rendering
require("render-markdown").setup({
	preset = "obsidian",
	heading = {
		enabled = true,
		width = "block",
		borer = true,
	},

	checkbox = {
		custom = {
			todo = { raw = "[-]", rendered = "󰥔", highlight = "RenderMarkdownTodo" },
			not_done = { raw = "[d]", rendered = "", highlight = "RednerMarkdownWarn" },
		},
	},

	dash = {
		enabled = true,
	},
})

-- marks
require("marks").setup({
	default_mappings = true,
})

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- Telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fbu", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
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
map("n", "<leader>fbr", "<cmd>Telescope file_browser<cr>")
map("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>")

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

require("lsp")
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

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.md",
	callback = function()
		local path = vim.api.nvim_buf_get_name(0)
		if not string.find(path, "templates/note.md") then
			local current_date = os.date("%Y-%m-%d")
			local file = vim.fn.expand("%:p")
			local content = vim.fn.readfile(file)
			local in_frontmatter = false
			for i, line in ipairs(content) do
				if line:match("^---") then
					in_frontmatter = true
				elseif line:match("^---") and in_frontmatter then
					break
				end
				if line:match("^date_modified:*") and in_frontmatter then
					content[i] = "date_modified: " .. current_date
					break
				end
			end
			vim.fn.writefile(content, file)
			vim.cmd("edit!")
		end
	end,
})
-- project config
require("nvim-projectconfig").setup({
	project_dir = "~/.config/projects-config",
})
