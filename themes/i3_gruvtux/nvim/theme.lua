return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            contrast = "", -- hard, soft, or empty,
            dim_inactive = true,
            transparent_mode = false,
        }
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            theme = 'gruvbox_dark'
            -- also try:
            -- gruvbox_light, gruvbox, gruvbox-material
        }

    },
}
