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

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")

map("n", " ", "za")
