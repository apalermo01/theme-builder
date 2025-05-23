-- local api = vim.api

-- local function open_floating_preview(filepath)
--     local buf = api.nvim_create_buf(false, true) -- Create a scratch buffer
--
--     -- Read the file content into the buffer
--     api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(filepath))
--
--     -- Define floating window dimensions
--     local width = math.floor(vim.o.columns * 0.8)
--     local height = math.floor(vim.o.lines * 0.8)
--     local opts = {
--         style = "minimal",
--         relative = "editor",
--         width = width,
--         height = height,
--         row = math.floor((vim.o.lines - height) / 2),
--         col = math.floor((vim.o.columns - width) / 2),
--         border = "rounded",
--     }
--
--     -- Create floating window
--     local win = api.nvim_open_win(buf, true, opts)
--
--     -- Set buffer options for preview
--     api.nvim_buf_set_option(buf, 'modifiable', false)
--     api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
--     api.nvim_win_set_option(win, 'wrap', false)
-- end
--
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

	config = function(_, opts)
		require("oil").setup(opts)
		-- map("n", "-", "<cmd>Oil --float <CR>", { desc = "Open parent directory" })
		map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
	end,
}
