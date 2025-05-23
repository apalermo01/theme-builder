-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "default_configs.nvim.lua.config.lazy.lsp.lsp-base"

-- EXAMPLE
local servers = { "html", "cssls", "clangd", "pylsp", "ts_ls", "svelte" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
lspconfig.ts_ls.setup {
  settings = {
    typescript = {
      format = {enable = true},
    },
    javascript = {
      format = {enable = true},
    },
    completions = {
      completeFunctionCalls = true
    },
  },
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}
