return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"nvim-lualine/lualine.nvim",
		enabled = false,
	},
	{
		"Famiu/feline.nvim",
		after = "catppuccin",
		config = function()
			require("feline").setup({
				components = require("catppuccin.groups.integrations.feline").get(),
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		opts = {
			options = {
				themable = false,
				separator_style = "slope",
				show_close_icon = true,
			},
		},
	},
}
