return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	config = function()
		require("lualine").setup({
            options = {
			    theme = "everforest",
			    globalstatus = true,
			    section_separators = { left = "", right = "" },
			    component_separators = { left = "", right = "" },
            }
		})
	end,
}
