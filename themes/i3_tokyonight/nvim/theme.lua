return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = 'night',
            dim_inactive = true,
            lualine_bold = true,

        },
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = 'tokyonight'
            }
        }
    },
}
