return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		enabled = false,
	},
	{
		"Famiu/feline.nvim",
		after = "catppuccin",
		config = function()
			local ctp_feline = require("catppuccin.groups.integrations.feline")

			ctp_feline.setup()

			require("feline").setup({
				components = ctp_feline.get(),
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		after = "catppuccin",
		config = function()
            local flavour = "mocha"
			local palette = require("catppuccin.palettes").get_palette(flavour)
			require("bufferline").setup({
				highlights = require("catppuccin.groups.integrations.bufferline").get({
					custom = {
						all = {
							background = { bg = palette.crust },
						},
					},
				}),
				options = {
					numbers = "buffer_id", -- or "buffer_id" for buffer numbers
					close_command = "bdelete! %d",
					right_mouse_command = "bdelete! %d",
					separator_style = "slope",
					show_close_icon = true,
					diagnostics = "nvim_lsp",
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "center",
						},
					},
				},
			})
		end,
	},
}
