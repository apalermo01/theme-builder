return {
	"nvim-telescope/telescope.nvim",
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function ()
		require('telescope').setup({})
		local builtin = require('telescope.builtin')
		map('n', '<leader>ff', builtin.find_files, { desc = 'find files' })
		map('n', '<leader>fg', builtin.git_files, { desc = 'git file search' })
		map('n', '<leader>fs', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = 'search for a string' })
	end

}

