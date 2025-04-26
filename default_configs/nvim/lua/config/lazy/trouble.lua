return {
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                auto_close = true,
                modes = {
                    diagnostics = {
                        auto_open = true,
                    }
                }
            })

            vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")

            vim.keymap.set("n", "[t", function()
                require("trouble").next({skip_groups = true, jump = true});
            end)

            vim.keymap.set("n", "]t", function()
                require("trouble").previous({skip_groups = true, jump = true});
            end)

        end
    },
}
