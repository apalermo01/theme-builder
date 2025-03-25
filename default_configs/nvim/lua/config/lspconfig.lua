local M = {}

M.on_attach = function(_, bufnr)
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end
	-- vim.api.nvim_create_autocmd("LspAttach", {
	-- 	callback = function(args)
	-- 		vim.notify("args = ", args)
	-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
	--
	-- 		if client.supports_method("textDocument/declaration*") then
	-- 			vim.notify("supports textDocument/delcaration")
	-- 			map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	-- 		end
	-- 	end,
	-- })
	-- vim.notify("setting gD")
	map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	map("n", "gd", vim.lsp.buf.declaration, opts("Go to definition"))
	map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
	map("n", "<leader>gT", vim.lsp.buf.type_definition, opts("Go to type definition"))
    map({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
    map("n", "gr", vim.lsp.buf.references, opts("Show references"))
    map({"n", "v", "i"}, "<C-k>", vim.lsp.buf.signature_help, opts("Show signature help"))
end

return M
