local set = vim.opt
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local group = augroup('config', {})

-- functions
function NixSettings()
    set.tabstop = 2
    set.shiftwidth = 2
    set.softtabstop = 2
end

-- General
set.guicursor = "n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20"

set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
autocmd('FileType', {
    group = group,
    pattern = { "nix" },
    callback = NixSettings
})

set.number = true
set.rnu = true

set.wrap = false

set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

set.hlsearch = false
set.incsearch = false

set.scrolloff = 8
set.signcolumn = "yes"

set.updatetime = 50
set.colorcolumn = "80"

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

vim.cmd([[let g:markdown_folding=1]])
vim.cmd([[set nofoldenable]])
-- folding behavior

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH
