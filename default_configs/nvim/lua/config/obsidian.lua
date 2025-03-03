-- obsidian
-- https://www.youtube.com/watch?v=1Lmyh0YRH-w
-- https://github.com/zazencodes/dotfiles/blob/main/nvim/lua/workflows.lua
require("obsidian").setup({
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
    new_notes_location = 'notes_subdir',
    notes_subdir = OBSIDIAN_NOTES_SUBDIR,

    note_id_func = function(title) 
        local suffix = ""
        if title ~= nil then 
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower() 
        else
            print("Invalid new note name - must have a title")
        end

        -- return tostring(os.date("%Y-%m-%d")) .. "_" .. suffix
        return suffix
    end
	--
	-- callbacks = {
	--
	-- 	-- update date modified
	-- 	pre_write_note = function(client, note)
	--            local path = tostring(note.path)
	--            if not string.find(path, "templates/note.md")  then
	--                local date_modified = os.date("%Y-%m-%d::%H:%M")
	--                local frontmatter = note:frontmatter()
	--                frontmatter["date_modified"] = date_modified
	--                note:save_to_buffer({frontmatter = frontmatter})
	--            end
	-- 	end,
	-- },
})

map("n", "<leader>oo", ":cd " .. OBSIDIAN_NOTES_DIR .. "<cr>")
map("n", "<leader>on", function()
	local current_file = vim.fn.expand("%:p")
	if string.find(current_file, OBSIDIAN_NOTES_DIR, 1, true) then
		vim.cmd("ObsidianTemplate note")
	else
		print("Cannot format file- not in notes directory")
	end
end)
map("n", "<leader>obl", ":ObsidianBacklinks<cr>")

-- move note to zettlekasten
map("n", "<leader>okc", ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-notes/5-full-notes<cr>:bd<cr>")

-- move note to source material
map("n", "<leader>osc", ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-notes/2-source-material<cr>:bd<cr>")

-- move note to zettlekasten (personal)
map("n", "<leader>okp", ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/1-notes-personal/5-full-notes<cr>:bd<cr>")

-- move note to source material (personal)
map("n", "<leader>osp", ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/1-notes-personal/2-source-material<cr>:bd<cr>")

-- move note to journal
map("n", "<leader>oj", ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/3-journal<cr>:bd<cr>")

-- delete note 
map("n", "<leader>odd", ":!rm '%:p'<cr>:bd<cr>")
