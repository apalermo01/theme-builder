return {
	"stevearc/oil.nvim",
	dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} }},
	lazy = false,

    opts = { 
        default_file_explorer = false
    },

    config = function(_, opts)
        require('oil').setup(opts)
        map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
    end

}
