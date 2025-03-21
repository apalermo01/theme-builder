return {
	"akinsho/bufferline.nvim",
    lazy = false,
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			numbers = "buffer_id", -- or "buffer_id" for buffer numbers
			close_command = "bdelete! %d",
			right_mouse_command = "bdelete! %d",
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "center",
				},
			},
			separator_style = "slant", -- or "thin" for a minimal look
			show_buffer_close_icons = true,
			show_close_icon = false,
			diagnostics = "nvim_lsp",
		},
	},

	keys = {
		{ "<leader>b", "<cmd>enew<CR>", "n", desc = "new buffer" },
		{
			"<leader>x",
			function()
				require("bufdelete").bufdelete(0, true)
			end,
			"n",
			desc = "delete this buffer",
		},
        { "<Tab>", "<cmd>BufferLineCycleNext<CR>", desc = "next buffer", silent = true},
        { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "previous buffer", silent = true}
	},
}
