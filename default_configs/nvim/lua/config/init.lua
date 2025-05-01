require("config.remap")
require("config.opts")
require("config.lazy_init")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local group = augroup("config", {})

-- Declare a global function to retrieve the current directory
-- https://github.com/stevearc/oil.nvim/blob/master/doc/recipes.md#show-cwd-in-the-winbar
function _G.get_oil_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return vim.fn.fnamemodify(dir, ":~")
	else
		-- If there is no current directory (e.g. over ssh), just show the buffer name
		return vim.api.nvim_buf_get_name(0)
	end
end

-- LSP maps
autocmd("LspAttach", {
	group = group,
	callback = function(e)
		local opts = { buffer = e.buf }
		local buf = e.buf
		local client = assert(vim.lsp.get_client_by_id(e.data.client_id))

		map("n", "<leader>lgd", function()
			vim.lsp.buf.definition()
		end, { buffer = buf, desc = "lsp: go to definition" })

		map("n", "K", function()
			vim.lsp.buf.hover()
		end, { buffer = buf, desc = "lsp: hover" })

		map("n", "<leader>lws", function()
			vim.lsp.buf.workspace_symbol()
		end, { buffer = buf, desc = "lsp: show workspace symbols" })

		-- map("n", "<leader>ld", function() vim.lsp.buf.open_float() end, { buffer = buf, desc = "lsp: open float" })
		-- map("n", "<leader>lof", function() vim.lsp.buf.open_float() end, { buffer = buf, desc = "lsp: open float" })
        --
		map("n", "<leader>lca", function()
			vim.lsp.buf.code_action()
		end, opts)
		map("n", "<leader>lrr", function()
			vim.lsp.buf.references()
		end, opts)
		map("n", "<leader>lrn", function()
			vim.lsp.buf.rename()
		end, opts)

		if client.supports_method("textDocument/signatureHelp") then
			map("n", "<C-s>", function()
				vim.lsp.buf.signature_help()
			end, opts)
		end

		map("n", "[d", function()
			vim.lsp.buf.goto_next()
		end, opts)
		map("n", "]d", function()
			vim.lsp.buf.goto_prev()
		end, opts)

		if client.name == "markdown_oxide" then
			map("n", "<leader>lrn", function()
				local file = vim.api.nvim_buf_get_name(0)
				if not file:find(OBSIDIAN_NOTES_DIR, 1, true) then
					vim.notify("Not in an Obsidian vault. Rename aborted.", vim.log.levels.WARN)
					return
				end
				vim.lsp.buf.rename()
			end, { desc = "safe rename" })
			map("n", "gf", function()
				vim.lsp.buf.definition()
			end, { buffer = buf, desc = "lsp: go to definition" })

			-- backlinks
			map("n", "obl", function()
				vim.lsp.buf.references()
			end, opts)
		end
	end,
})

-- obsidian: update date updated when saving a note
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.md",
	callback = function()
		local path = vim.api.nvim_buf_get_name(0)
		if not string.find(path, "templates/note.md") then
			local current_date = os.date("%Y-%m-%d")
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

			local in_frontmatter = false
			for i, line in ipairs(lines) do
				if line:match("^---") then
					if in_frontmatter then
						break
					else
						in_frontmatter = true
					end
				elseif in_frontmatter and line:match("^date_modified:") then
					lines[i] = "date_modified: " .. current_date
					vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
					break
				end
			end
		end
	end,
})

-- Automatic file / heading renaming
local function get_vault_root(fname)
	local paths = {
		"0-technical-notes",
		"1-notes",
	}
	for _, sub in ipairs(paths) do
		local full = OBSIDIAN_NOTES_DIR .. "/" .. sub
		if fname:find(full, 1, true) then
			return full
		end
	end
	return vim.fn.getcwd()
end

require("nvim-lspconfig").markdown_oxide.setup({
	capabilities = capabilities,
	root_dir = function(fname)
		return get_vault_root(fname)
	end,
})

-- trouble: only open when there's something that will crash the program
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function(args)
		local bufnr = args.buf
		local error = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
		if errors ~= nil and #errors > 0 then
			require("trouble").open({
				mode = "diagnostics",
				filter = { buf = 0 },
				focus = false,
				pinned = true,
			})
		end
	end,
})

-- trouble: close when closing buffer
vim.api.nvim_create_autocmd("BufWipeout", {
	callback = function(args)
		local trouble = require("trouble")
		if trouble.is_open() then
			local view = trouble.get_view()
			if view and view.source.buf == args.buf then
				trouble.close()
			end
		end
	end,
})
