return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "macchiato",
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
			local flavour = "macchiato"
			local palette = require("catppuccin.palettes").get_palette(flavour)

			local highlight_groups_for_underline = {
				"indicator_selected",
				"buffer_selected",
				"close_button_selected",
				"numbers_selected",
				"diagnostic_selected",
				"info_selected",
				"warning_selected",
			}
			local custom_highlights = { all = { fill = { bg = palette.crust } } }

			-- Add underline styling to each desired highlight group
			for _, group in ipairs(highlight_groups_for_underline) do
				custom_highlights.all[group] = {
					sp = palette.red,
					bg = "NONE",
					underline = true,
				}
			end

			require("bufferline").setup({
				highlights = require("catppuccin.groups.integrations.bufferline").get({
                    custom = custom_highlights
				}),
				options = {
					numbers = "buffer_id", -- or "buffer_id" for buffer numbers
					close_command = "bdelete! %d",
					right_mouse_command = "bdelete! %d",
					show_close_icon = true,
					diagnostics = "nvim_lsp",
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "center",
						},
					},
					indicator = {
						style = "underline",
					},
					separator_style = { "", "" },
				},
			})
		end,
	},
}
