return {
	{
		"shaunsingh/nord.nvim",
		priority = 1000,
		config = function()
			vim.g.nord_contrast = true
			require("nord").set()
		end,
	},
}
