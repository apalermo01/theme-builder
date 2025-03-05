require("bufferline").setup({
	options = {
		numbers = "buffer_id", -- or "buffer_id" for buffer numbers
		close_command = "bdelete! %d",
		right_mouse_command = "bdelete! %d",
		offsets = {
			{ filetype = "NvimTree", text = "File Explorer", text_align = "center" },
		},
		separator_style = "slant", -- or "thin" for a minimal look
		show_buffer_close_icons = true,
		show_close_icon = false,
		diagnostics = "nvim_lsp",
	},
})

