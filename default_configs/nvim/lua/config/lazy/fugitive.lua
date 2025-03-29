return {
	"tpope/vim-fugitive",
	config = function()
		map("n", "<leader>gs", vim.cmd.Git)
	end
}
