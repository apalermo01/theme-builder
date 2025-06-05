return {
	"stevearc/oil.nvim",
	dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
	lazy = false,

	opts = {
		default_file_explorer = false,
		keymaps = {
			["<C-s>"] = { "actions.select", opts = { horizontal = true } },
			["<C-v>"] = { "actions.select", opts = { vertical = true } },
			["<C-h>"] = false,
			["<C-l>"] = false,
			-- ["<leader>pv"] = {
			-- 	callback = function()
			-- 		local oil = require("oil")
			-- 		local file_path = oil.get_current_dir() -- Get the current file path from oil
			-- 		if file_path then
			-- 			open_floating_preview(file_path)
			-- 		end
			-- 	end,
			-- },
		},

		win_options = {
			winbar = "%!v:lua.get_oil_winbar()",
		},

		view_options = {

            -- show hidden files only if we're in dotfiles repo,
            -- in the config folder, or if there are github actions
			show_hidden = function()
				local current_file = vim.fn.expand("%:p")

				return string.find(current_file, "git/dotfiles/", 1, true)
					or string.find(current_file, ".config", 1, true)
					or vim.fn.isdirectory(
                        vim.fn.getcwd() .. "/.github"
                    ) == 1
			end,
			preview_win = {},
		},
	},
}
