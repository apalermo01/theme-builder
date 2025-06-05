return {
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				auto_close = true,
			})
		end,
	},
}
