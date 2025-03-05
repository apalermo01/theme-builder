return {
	"neanias/everforest-nvim",
	priority = 1000,
	config = function()
		require("everforest").setup({
			background = "hard",
			italics = true,
			ui_contrast = "high",
			dim_inactive_windows = true,
		})
	end,
}
