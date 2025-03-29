return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        opts = {
            options = {
                theme = "nord",
                globalstatus = true,
            },
        },
    },

    {
        {
            "shaunsingh/nord.nvim",
            priority = 1000,
            config = function()
                vim.g.nord_contrast = true
                require("nord").set()
            end,
        },
    }
}
