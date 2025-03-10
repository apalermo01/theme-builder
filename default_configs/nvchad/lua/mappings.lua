require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "oo", "o<ESC>k")
map("n", "OO", "O<ESC>j")

-- map("n", "<C-t>", ":NvimTreeToggle<cr>")
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")

-- Goto preview
map("n", "<leader>gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>")
map("n", "<leader>gP", "<cmd>lua require('goto-preview').close_all_win()<CR>")

map('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Telescope find files' })
map('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Telescope buffers' })
map('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Telescope help tags' })
