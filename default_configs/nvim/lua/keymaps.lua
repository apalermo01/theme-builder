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

-- terminal
map("n", "<leader>tr", "<cmd>tabnew | term<CR>", { desc = "open terminal in new tab" })

-- movement
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")

map("n", " ", "za")

-- quality of life stuff
vim.cmd([[ nnoremap <leader>/ /\\<\\><Left><Left> ]])


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

-- cheatsheet
map("n", "<leader>?", "<cmd>Cheatsheet<CR>", { desc = "open cheatsheet"})

-- nvim tree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "toggle nvimtree"})
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "focus nvimtree"})

-- bufferline
map("n", "<leader>b", "<cmd>enew<CR>", {desc = "new buffer"})
map("n", "<leader>x", function()
    require("bufdelete").bufdelete(0, true)
end, {desc = "close current buffer"})
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "next buffer", silent = true})
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "previous buffer", silent = true})

-- -- debugging
-- map("n", "<leader>dB", function()
--     require("dap").set_breakpoint()
-- end, { desc = "debug method", ft = "python" })

-- debugging (python)
map("n", "<leader>dPt", function()
    require("dap-python").test_method()
end, { desc = "debug method",  })

map("n", "<leader>dPc", function()
    require("dap-python").test_class()
end, { desc = "debug class", })


