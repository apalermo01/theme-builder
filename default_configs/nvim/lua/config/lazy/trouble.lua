return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                auto_close = true,
            })

            vim.keymap.set("n", "<leader>tt", function()
                require("trouble").toggle({
                    mode = "diagnostics",
                    filter = { buf = 0 },
                    pinned = true,
                    focus = false
                })
            end)

            vim.keymap.set("n", "[t", function()
                require("trouble").next({skip_groups = true, jump = true});
            end)

            vim.keymap.set("n", "]t", function()
                require("trouble").previous({skip_groups = true, jump = true});
            end)

        end
    },
}
