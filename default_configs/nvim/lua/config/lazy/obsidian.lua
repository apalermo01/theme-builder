
-- https://www.youtube.com/watch?v=1Lmyh0YRH-w
-- https://github.com/zazencodes/dotfiles/blob/main/nvim/lua/workflows.lua
--
return {
	"epwalsh/obsidian.nvim",
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
	},

	opts = {
		ui = {
			enable = false,
		},
		workspaces = {
			{
				name = "technical notes",
				path = OBSIDIAN_NOTES_DIR .. "/0-technical-notes",
				overrides = {
					notes_subdir = "0-inbox"
				},
			},
			{
				name = "notes",
				path = OBSIDIAN_NOTES_DIR .. "/1-notes",
				overrides = {
					notes_subdir = "0-inbox"
				},
			},
		},
		disable_frontmatter = false,
		templates = {
			folder = OBSIDIAN_TEMPLATE_FOLDER,
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		new_notes_location = "current_dir",
		notes_subdir = OBSIDIAN_NOTES_SUBDIR,

		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				print("Invalid new note name - must have a title")
			end

			return suffix
		end,
	},

	keys = {
		{ "<leader>oo", ":cd " .. OBSIDIAN_NOTES_DIR .. "<CR>", "n", desc = "jump to notes directory" },
		{
			"<leader>on",
			function()
				local current_file = vim.fn.expand("%:p")
				if string.find(current_file, OBSIDIAN_NOTES_DIR, 1, true) then
					vim.cmd("ObsidianTemplate note")
				else
					print("Cannot format file- not in notes directory")
				end
			end,
			"n",
			desc = "format current file as a note",
		},

		{ "<leader>obl", "<cmd>ObsidianBacklinks<CR>", "n", desc = "show backlinks in telescope" },

	{
		"<leader>okc",
		":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-technical-notes/5-full-notes<cr>:bd<CR>",
		"n",
		desc = "move to craft notes",
	},
	{
		"<leader>okp",
		":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/1-notes/5-full-notes<cr>:bd<CR>",
		"n",
		desc = "move to personal notes",
	},
	{
		"<leader>osc",
		":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-technical-notes/2-source-material<cr>:bd<CR>",
		"n",
		desc = "move to source material",
	},
	{
		"<leader>osp",
		":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/1-notes/2-source-material<cr>:bd<CR>",
		"n",
		desc = "move to source material (personal)",
	},
	{
		"<leader>odd",
		":!rm '%:p'<CR>:bd<CR>",
		"n",
		desc = "delete note",
	},
},
}
