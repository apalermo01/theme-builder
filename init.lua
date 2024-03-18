-- install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local set = vim.opt
local g = vim.g
local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

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


-----------------------------
-- define functions ---------
-----------------------------
-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets
local function keymap()
  if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
    return '⌨ ' .. vim.b.keymap_name
  end
  return ''
end

-----------------------------
-- define plugins -----------
-----------------------------

g.mapleader = ","
require("lazy").setup({
    -- start screen
    "mhinz/vim-startify",

    -- colorschemes
    "rafi/awesome-vim-colorschemes",
    "Mofiqul/dracula.nvim",

    -- other useful stuff
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim"}
	},
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"}
    },

    -- "vimwiki/vimwiki",

    {
        "lukas-reineke/headlines.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "tree-sitter-grammars/tree-sitter-markdown",
        },
        config=true,
    },

    -- markdown preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
          vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    
    -- unicode
    "chrisbra/unicode.vim",


    -- telescope
    {
        'nvim-telescope/telescope.nvim', tag='0.1.6'
    },

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter'
    }
})
  

-----------------------------
-- settings -----------------
-----------------------------
-- General
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
vim.cmd[[filetype plugin on]]
vim.cmd[[setlocal spell spelllang=en_us]]

-- UI
set.so = 7
set.wildmenu = true

-- Colors / fonts
set.background = "dark"
set.encoding = "utf8"
vim.cmd[[colorscheme dracula]]
vim.cmd[[set guifont=JetBrainsMono\ Nerd\ Font\ Mono]]
-- other script-like things
vim.cmd[[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]

-- make Esc clear search highlights
vim.cmd[[ nnoremap <esc> :noh<return><esc> ]]

-----------------------------
-- key mappings -------------
-----------------------------
-- newlines above and below
keymap("n", "oo", "o<Esc>k", default_opts)
keymap("n", "OO", "O<Esc>j", default_opts)

-- tabs
keymap("n", "<leader>tn", ":tabnew<cr>", {})
keymap("n", "<leader>t<leader>", ":tabnext", {})
keymap("n", "<leader>tm", ":tabmove", {})
keymap("n", "<leader>tc", ":tabclose", {})
keymap("n", "<leader>to", ":tabonly", {})

-- neotree
-- keymap("n", "/", ":Neotree toggle current reveal_force_cwd<cr>", default_opts)
-- keymap("n", "|", ":Neotree toggle reveal<cr>", default_opts)
vim.cmd[[ nnoremap <C-t> :Neotree toggle reveal<cr> ]]

-----------------------------
-- statusline ---------------
-----------------------------
require('lualine').setup {
    options = {
        theme = "dracula-nvim",
        component_separators = "✓",
        section_separators = {left="", right=""},
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
    }
}

-----------------------------
-- vimwiki ------------------
-----------------------------
vim.cmd[[
    let wiki_1 = {}
    let wiki_1.path = "~/Documents/github/planning-docs/"
    let wiki_1.syntax = "markdown"
    let wiki_1.ext = ".md"
    let g:vimiki_list = [wiki_1]
    let g:vimiki_global_ext = 0
]]

-----------------------------
-- headlines ----------------
-----------------------------
require("headlines").setup {
    markdown = {
        query = vim.treesitter.query.parse(
            "markdown",
            [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
                (block_quote (paragraph (block_continuation) @quote))
                (block_quote (block_continuation) @quote)
            ]]
        ),
        headline_highlights = { "Headline" },
        bullet_highlights = {
            "@text.title.1.marker.markdown",
            "@text.title.2.marker.markdown",
            "@text.title.3.marker.markdown",
            "@text.title.4.marker.markdown",
            "@text.title.5.marker.markdown",
            "@text.title.6.marker.markdown",
        },
        bullets = { "◉", "○", "✸", "✿" },
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        dash_string = "-",
        quote_highlight = "Quote",
        quote_string = "┃",
        fat_headlines = true,
        fat_headline_upper_string = "▃",
        fat_headline_lower_string = "🬂",
    }
}

-----------------------------
-- telescope ----------------
-----------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

