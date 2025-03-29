return {

    {
        "olimorris/onedarkpro.nvim",
        priority = 1000, -- Ensure it loads first
    },
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = 'onedark'
            }
        }
    },
}
