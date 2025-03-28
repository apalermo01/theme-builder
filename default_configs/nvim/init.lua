-- Variables
OBSIDIAN_NOTES_DIR = os.getenv("OBSIDIAN_NOTES_DIR") or "/home/alex/Documents/git/notes"
OBSIDIAN_NOTES_SUBDIR = os.getenv("OBSIDIAN_NOTES_SUBDIR") or "0-inbox"
OBSIDIAN_TEMPLATE_FOLDER = os.getenv("OBSIDIAN_TEMPLATE_FOLDER") or "5-templates"

map = vim.keymap.set

require("config")
