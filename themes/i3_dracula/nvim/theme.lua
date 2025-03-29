return {
    {
        -- "Mofiqul/dracula.nvim",
        -- priority = 1000
        -- "binhtran432k/dracula.nvim",
        -- lazy = false,
        -- priority = 1000,
        -- opts = {}
        "maxmx03/dracula.nvim",
        lazy = false,
        priority = 1000,

    },

    {
        "nvim-lualine/lualine.nvim",
        after = "dracula",
        opts = {
            theme = 'dracula'
        }

    },
    -- {
    --     "akinsho/bufferline.nvim",
    --     after = "dracula",
    --     opts = {
    --         options = {
    --             separator_style = 'thick'
    --         }
    --     }
    --     -- config = function(_, opts)
    --     --     require('bufferline').setup(opts)
    --     --     -- local palette = require("dracula").colors()
    --     --     -- local color = palette.menu
    --     --     -- vim.api.nvim_set_hl(0, 'BufferLineFill', { bg = "#FF0000" })
    --     -- end,
    -- },
}
