return {
    "numToStr/FTerm.nvim",
    config = function(_, opts)
        require('FTerm').setup(opts)
        map("n", "<leader>ft", "<cmd>lua require('FTerm').toggle()<cr>")
        map("t", "<leader>ft", "<C-\\><C-n><cmd>lua require('FTerm').toggle()<cr>")
        -- map("t", "<Esc>",      "<C-\\><C-n><cmd>lua require('FTerm').exit()<cr>")
    end
}
