return {
    {
        "nvim-telescope/telescope.nvim",
	    dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            defaults = {
                initial_mode = 'normal',
                dynamic_preview_title = true,
            }
        },
	    config = function(_, opts)
	    	require('telescope').setup(opts)
	    	local builtin = require('telescope.builtin')
	    	map('n', '<leader>ff', builtin.find_files, { desc = 'find files' })
	    	map('n', '<leader>fw', builtin.live_grep, { desc = 'live grep' })
	    	map('n', '<leader>fg', builtin.git_files, { desc = 'git file search' })
	    	map('n', '<leader>fbb', builtin.buffers, { desc = 'git file search' })
	    	map('n', '<leader>fs', function()
	    		builtin.grep_string({ search = vim.fn.input("Grep > ") })
	    	end, { desc = 'search for a string' })
	    end
    },

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function(_, opts)
            map("n", "<leader>fb", "<cmd>Telescope file_browser<CR>", { desc = "file browser" })
        end
	},
}

