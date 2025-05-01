local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local group = augroup('config', {})

autocmd('LspAttach', {
    group = group,
    callback = function(e)
        local opts = { buffer = e.buf }
        local buf = e.buf
        local client = assert(vim.lsp.get_client_by_id(e.data.client_id))

        map("n", "gd", function() vim.lsp.buf.definition() end, { buffer = buf, desc = "lsp: go to definition" })

        map("n", "<leader>lgd", function() vim.lsp.buf.definition() end, { buffer = buf, desc = "lsp: go to definition" })
        map("n", "K", function() vim.lsp.buf.hover() end, { buffer = buf, desc = "lsp: hover" })
        map("n", "<leader>lws", function() vim.lsp.buf.workspace_symbol() end,
            { buffer = buf, desc = "lsp: show workspace symbols" })
        -- map("n", "<leader>ld", function() vim.lsp.buf.open_float() end, { buffer = buf, desc = "lsp: open float" })
        -- map("n", "<leader>lof", function() vim.lsp.buf.open_float() end, { buffer = buf, desc = "lsp: open float" })
        map("n", "<leader>lca", function() vim.lsp.buf.code_action() end, opts)
        map("n", "<leader>lrr", function() vim.lsp.buf.references() end, opts)
        map("n", "<leader>lrn", function() vim.lsp.buf.rename() end, opts)

        if client.supports_method('textDocument/signatureHelp') then
            map("n", "<C-s>", function() vim.lsp.buf.signature_help() end, opts)
        end

        map("n", "[d", function() vim.lsp.buf.goto_next() end, opts)
        map("n", "]d", function() vim.lsp.buf.goto_prev() end, opts)

        if client.name == 'markdown_oxide' then
            map("n", "<leader>lrn", function()
                local file = vim.api.nvim_buf_get_name(0)
                if not file:find(OBSIDIAN_NOTES_DIR, 1, true) then
                    vim.notify("Not in an Obsidian vault. Rename aborted.", vim.log.levels.WARN)
                    return
                end
                vim.lsp.buf.rename()
            end, { desc = "safe rename" })
            map("n", "gf", function() vim.lsp.buf.definition() end,
                { buffer = buf, desc = "lsp: go to definition" })
            -- backlinks
            map("n", "obl", function() vim.lsp.buf.references() end, opts)
        end
    end
})


return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "f3fora/cmp-spell",
        "Dynge/gitmoji.nvim",
    },

    config = function()
        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            }
        })

        -- bigquery
        local proj_file = vim.fn.expand("$HOME/.bq_project")
        if vim.fn.filereadable(proj_file) ~= 0 then
            local project_id = vim.fn.trim(vim.fn.readfile(proj_file)[1] or "")
            if project_id ~= "" then
                require("default_configs.nvim.lua.config.lazy.lsp.lsp-base").bqls.setup {
                    settings = {
                        project_id = project_id,
                    },
                }
            end

        end
    end
}
