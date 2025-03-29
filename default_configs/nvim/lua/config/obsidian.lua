-- obsidian
-- https://www.youtube.com/watch?v=1Lmyh0YRH-w
-- https://github.com/zazencodes/dotfiles/blob/main/nvim/lua/workflows.lua

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
