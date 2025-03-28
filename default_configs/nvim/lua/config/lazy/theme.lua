function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	{
	'rose-pine/neovim',
	opts = {
		variant = 'main',
		styles = {
			transparency = true
		}
	},
	config = function(_, opts)
		require('rose-pine').setup(opts)
		vim.cmd.colorscheme('rose-pine')
	end
},



}
