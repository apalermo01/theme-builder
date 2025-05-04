-- Globals
OBSIDIAN_NOTES_DIR = os.getenv("OBSIDIAN_NOTES_DIR") or "/home/alex/Documents/git/notes"
OBSIDIAN_NOTES_SUBDIR = os.getenv("OBSIDIAN_NOTES_SUBDIR") or "0-inbox"
OBSIDIAN_TEMPLATE_FOLDER = os.getenv("OBSIDIAN_TEMPLATE_FOLDER") or "5-templates"

map = vim.keymap.set

-- boolean flag to check if we're running nix
function is_nixos()
	local os_release = vim.fn.readfile("/etc/os-release")
	for _, line in ipairs(os_release) do
		if line:match("^ID=nixos") then
			return true
		end
	end
	return false
end

IS_NIXOS = is_nixos()

-- return 2 variants of a function depending on whether or not we're running nix
-- borrowed from https://github.com/NicoElbers/nixPatch-nvim/tree/main 
switchNix = function(nonNix, nix)
    if vim.g.nix == true then 
        return nix
    else
        return nonNix
    end 
end

require("config")

-- local log = require('cmp.utils.debug').log
-- log.enable('DEBUG')  
