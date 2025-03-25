require("mason").setup()
require("mason-lspconfig").setup()

local border = "single"

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}
local servers = { "html", "cssls", "clangd", "pyright", "ts_ls", "lua_ls", "gopls" }
local nvlsp = require("config.lspconfig")

for _, lsp in ipairs(servers) do
	require("lspconfig")[lsp].setup({
		handlers = handlers,
		on_attach = nvlsp.on_attach,
	})
end
