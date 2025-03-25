local client = vim.lsp.start_client({
	name = "educationalsp",
	cmd = { "/home/alex/Documents/git/educationalsp/main" },
    on_attach = require("config.lspconfig").on_attach
})

if not client then
	vim.notify("You didn't do the client thing good")
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.lsp.buf_attach_client(0, client)
	end,
})
