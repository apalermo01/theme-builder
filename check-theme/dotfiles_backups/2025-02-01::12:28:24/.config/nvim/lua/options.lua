require("nvchad.options")

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
o.termguicolors = true

require("colorizer").setup({
	filetypes = { "*" },
	json = {
		names = false,
	},
})

require("render-markdown").setup({
	file_types = { "markdown", "md", "quarto" },
})

require("nvim-tree").setup({
	view = { adaptive_size = true },
})

vim.diagnostic.config({
	virtual_text = false,
})

vim.api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

-- close nvim tree if it's the last thing open
vim.api.nvim_create_autocmd("BufEnter", {
	nested = true,
	callback = function()
		if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
			vim.cmd("quit")
		end
	end,
})
o.updatetime = 300