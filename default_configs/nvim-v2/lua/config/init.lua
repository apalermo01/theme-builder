require("config.remap")
require("config.opts")
require("config.lazy_init")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local group = augroup('config', {})


autocmd('LspAttach', {
    group = group,
    callback = function(e)
        local opts = { buffer = e.buf }
        map("n", "gd", function() vim.lsp.buf.definition() end, opts)
        map("n", "K", function() vim.lsp.buf.hover() end, opts)
        map("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        map("n", "<leader>vd", function() vim.lsp.buf.open_float() end, opts)
        map("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        map("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        map("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        map("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        map("n", "[d", function() vim.lsp.buf.goto_next() end, opts)
        map("n", "]d", function() vim.lsp.buf.goto_prev() end, opts)
    end
})

vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
