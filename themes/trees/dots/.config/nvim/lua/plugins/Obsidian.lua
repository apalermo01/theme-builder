return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "knowledge-base",
        path = "/home/alex/Documents/git/knowledge-base",
      },
    },
    ui = { enable = true },
  },
}
