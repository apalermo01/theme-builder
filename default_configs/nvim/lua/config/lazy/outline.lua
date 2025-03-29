return {
    "hedyhli/outline.nvim",
    config = function()
        -- Example mapping to toggle outline
        vim.keymap.set("n", "<leader>ol", "<cmd>Outline<CR>",
            { desc = "Toggle Outline" })

        require("outline").setup {
            outline_window = {
                position = 'right',
                focus_on_open = false,
            },

            outline_items = {
                show_symbol_lineno = true
            },

            preview_window = {
                auto_preview = false,
            },
            keymaps = {
                goto_location = '<Tab>',
                fold_toggle = '<CR>'

            }

        }
    end,
}
