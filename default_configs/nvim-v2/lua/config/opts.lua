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
vim.cmd([[set spellfile=~/.config/en.utf-8.add]])
vim.cmd([[set guifont=JetBrainsMono\ Nerd\ Font\ Mono]])
vim.cmd([[set completeopt=menu,preview,menuone,noselect]])

-- UI
set.so = 7
vim.o.cursorlineopt = "both"
vim.o.termguicolors = true
vim.cmd([[set conceallevel=2]])
vim.cmd([[set foldcolumn=1]])
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

-- folding behavior
vim.cmd([[let g:markdown_folding=1]])
vim.cmd([[set nofoldenable]])

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

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
