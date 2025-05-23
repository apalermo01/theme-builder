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
	    	map('n', '<leader>fa', function()
                builtin.find_files({ hidden=true, no_ignore=true })
            end, { desc = 'find (all) files' })
	    	map('n', '<leader>fj', builtin.jumplist, { desc = 'jumplist' })
	    	map('n', '<leader>fg', builtin.live_grep, { desc = 'live grep' })
	    	-- map('n', '<leader>fg', builtin.git_files, { desc = 'git file search' })
	    	map('n', '<leader>fbu', builtin.buffers, { desc = 'search open buffers' })
	    	map('n', '<leader>fo', builtin.oldfiles, { desc = 'search old files' })
	    	map('n', '<leader>fss', builtin.spell_suggest, { desc = 'spell suggest' })
	    	map('n', '<leader>fr', builtin.resume, { desc = 'resume' })
	    	map('n', '<leader>f"', builtin.registers, { desc = 'list registers' })
	    	map('n', '<leader>fma', builtin.marks, { desc = 'list marks' })
	    	map('n', '<leader>fmp', builtin.man_pages, { desc = 'list manpages' })
	    	map('n', '<leader>fw', function()
	    		builtin.grep_string({ search = vim.fn.input("Grep > ") })
	    	end, { desc = 'search for a string' })
	    end
    },

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function(_, opts)
            map("n", "<leader>fbb", "<cmd>Telescope file_browser<CR>", { desc = "file browser" })
        end
	},
}

