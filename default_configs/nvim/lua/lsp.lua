require("mason").setup()
require("mason-lspconfig").setup()

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}
local servers = { "html", "cssls", "clangd", "pylsp", "ts_ls", "lua_ls" }
for _, lsp in ipairs(servers) do
	require("lspconfig")[lsp].setup({ handlers = handlers })
end
