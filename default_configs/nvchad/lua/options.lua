require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!
o.termguicolors = true

require("colorizer").setup {
  filetypes = { "*" }
}
