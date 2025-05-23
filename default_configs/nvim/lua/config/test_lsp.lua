local client = vim.lsp.start_client({
	cmd = { "/home/alex/Documents/git/educationalsp/main" },
	name = "educationalsp",
})

if not client then
	vim.notify("you didn't do the client thing good")
	return
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.lsp.buf_attach_client(0, client)
	end,
})
