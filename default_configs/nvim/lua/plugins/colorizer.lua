return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			filetypes = { "*" },
			DEFAULT_OPTIONS = {
				RGB = true,
				RRGGBB = true,
				names = false,
				RRGGBBAA = true,
				css = true,
				css_fn = true,
			},
		})
	end,
}
