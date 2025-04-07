return {

    {
        "rose-pine/neovim",
        name = "rose-pine",
        opts = {
            variant = 'main',
            dim_inactive_windows = true,
        }
    },
    {
        'akinsho/bufferline.nvim',
        event = 'ColorScheme',
        config = function()
            local highlights = require('rose-pine.plugins.bufferline')
            require('bufferline').setup({ highlights = highlights })
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        event = 'ColorScheme',
        config = function()
            require('lualine').setup({
                options = {
                    --- @usage 'rose-pine' | 'rose-pine-alt'
                    theme = 'rose-pine'
                }
            })
        end
    },
}
