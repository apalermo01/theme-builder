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

require("opts")
require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.debug" },
		{ import = "theme" },
	},
})
require("keymaps")
require("ftype_settings")
require("lsp")
require("theme")

vim.cmd.colorscheme("catppuccin")

-- With the above settings, hitting " " after the markdown file opens toggles ALL folds,
-- so run this to automatically open all folds so that " " (za) has the desired behavior
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.md",
	command = "normal! zR",
})

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
