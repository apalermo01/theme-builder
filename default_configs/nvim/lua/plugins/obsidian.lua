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
				name = "notes",
				path = OBSIDIAN_NOTES_DIR,
				overrides = {
					notes_subdir = OBSIDIAN_NOTES_SUBDIR,
				},
			},
		},
		disable_frontmatter = true,
		templates = {
			folder = OBSIDIAN_TEMPLATE_FOLDER,
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		new_notes_location = "notes_subdir",
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
}
