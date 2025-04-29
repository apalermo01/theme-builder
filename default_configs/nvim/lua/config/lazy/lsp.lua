local function is_nixos()
    local os_release = vim.fn.readfile("/etc/os-release")
    for _, line in ipairs(os_release) do
        if line:match("^ID=nixos") then
            return true
        end
    end
    return false
end

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
        local nixos = is_nixos()

        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                nix = { "nixfmt" },
                sql = { "sqlfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },
                sh = { "shfmt" },
                md = { "mdformat" },
                markdown = { "mdformat" },
                yaml = { "yamlfix" },
                yml = { "yamlfix" },

            }
        })

        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())
        require('fidget').setup({})
        require('mason').setup()
        require("mason-lspconfig").setup({
            automatic_installation = not nixos,
            ensure_installed = nixos and {
                "lua_ls",
                "html",
                "cssls",
                "clangd",
                "pyright",
                "tsserver",
                "jsonls",
                "nil_ls",
                "bashls",
            } or {
                "lua_ls",
                "html",
                "cssls",
                "clangd",
                "pyright",
                "tsserver",
                "jsonls",
                "nil_ls",
                "markdown_oxide",
                "bashls",
            },

            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities
                    })
                end,

                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        cmd = nixos and { "lua-language-server" } or nil,
                        capabilities = capabilities
                    })
                end,

                ["markdown_oxide"] = function()
                    require("lspconfig").markdown_oxide.setup({
                        cmd = nixos and { "markdown-oxide" } or nil,
                        capabilities = vim.tbl_deep_extend(
                            'force',
                            capabilities,
                            {
                                workspace = {
                                    didChangeWatchedFiles = {
                                        dynamicRegistration = true,
                                    }
                                }
                            }
                        )
                    })
                end,

                ["nil_ls"] = function()
                    require("lspconfig").nil_ls.setup({
                        autostart = true,
                        settings = {
                            ['nil'] = {
                                testSetting = 42,
                                formatting = {
                                    command = { "nixfmt-rfc-style" },
                                }
                            }
                        }
                    })
                end
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local luasnip = require("luasnip")
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end
            },

            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-j>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-k>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-space>'] = cmp.mapping.complete(),
            }),

            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'render-markdown' },
                { name = 'obsidian' },
                -- { name = 'spell' },
                -- { name = 'gitmoji' },
                { name = 'path' }
            })
        })

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

        -- `/` cmdline setup.
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- `:` cmdline setup.
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                {
                    name = "cmdline",
                    option = {
                        ignore_cmds = { "Man", "!" },
                    },
                },
            }),
        })

        map("n", "<leader>fm", function()
            require("conform").format({ lsp_fallback = true })
        end, { desc = "general format file" })

        -- bigquery
        local proj_file = vim.fn.expand("$HOME/.bq_project")
        if vim.fn.filereadable(proj_file) ~= 0 then
            local project_id = vim.fn.trim(vim.fn.readfile(proj_file)[1] or "")
            if project_id ~= "" then
                require("lspconfig").bqls.setup {
                    settings = {
                        project_id = project_id,
                    },
                }
            end

        end
    end
}
