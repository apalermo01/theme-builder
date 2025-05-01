-- Variables
OBSIDIAN_NOTES_DIR = os.getenv("OBSIDIAN_NOTES_DIR") or "/home/alex/Documents/git/notes"
OBSIDIAN_NOTES_SUBDIR = os.getenv("OBSIDIAN_NOTES_SUBDIR") or "0-inbox"
OBSIDIAN_TEMPLATE_FOLDER = os.getenv("OBSIDIAN_TEMPLATE_FOLDER") or "5-templates"

map = vim.keymap.set

function is_nixos()
	local os_release = vim.fn.readfile("/etc/os-release")
	for _, line in ipairs(os_release) do
		if line:match("^ID=nixos") then
			return true
		end
	end
	return false
end

nixos = is_nixos()
require("config")

-- local log = require('cmp.utils.debug').log
-- log.enable('DEBUG')  
