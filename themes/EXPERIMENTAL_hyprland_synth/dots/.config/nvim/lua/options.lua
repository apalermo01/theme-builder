require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!
o.termguicolors = true

require("colorizer").setup {
  filetypes = { "*" },
  json = {
    names = false;
  }
}

require("render-markdown").setup({
  file_types = {'markdown', 'md', 'quarto'},
})

require("nvim-tree").setup({
  view = { adaptive_size = true }
})

vim.diagnostic.config({
  virtual_text = false,
})

vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function() 
    vim.diagnostic.open_float(nil, {focusable=false})
  end,
})
o.updatetime = 300
