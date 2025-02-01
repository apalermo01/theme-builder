return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  },

  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    config = true,
  },

  {
    "williamboman/mason.nvim",
  },
  {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'md'},
      },
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "typescript",
        "tsx",
        "svelte"
  		},
  	},
    highlight = {
      enable = true,
    }
  },
  {
    "ekickx/clipboard-image.nvim"
  },
  {
    "epwalsh/obsidian.nvim",
  },
  {
    'nvim-lua/plenary.nvim'
  },
  {
    'hrsh7th/nvim-cmp'
  }
}