local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local group = augroup("config", {})

-- LSP maps
autocmd("LspAttach", {
	group = group,
	callback = function(e)
		local opts = { buffer = e.buf }
		local buf = e.buf
		local client = assert(vim.lsp.get_client_by_id(e.data.client_id))

		map("n", "<leader>ld", function()
			vim.lsp.buf.definition()
		end, { buffer = buf, desc = "lsp: go to definition" })
        
		map("n", "gd", function()
			vim.lsp.buf.definition()
		end, { buffer = buf, desc = "lsp: go to definition" })

		-- map("n", "<leader>lpd", function()
		-- 	vim.lsp.buf.definition()
		-- end, { buffer = buf, desc = "lsp: go to definition" })

		map("n", "K", function()
			vim.lsp.buf.hover()
		end, { buffer = buf, desc = "lsp: hover" })

        map("n", "<leader>lk", function()
            vim.diagnostic.open_float()
        end, {buffer = buf, desc = "show error"})

		map("n", "<leader>lws", function()
			vim.lsp.buf.workspace_symbol()
		end, { buffer = buf, desc = "lsp: show workspace symbols" })

		--
		map("n", "<leader>la", function()
			vim.lsp.buf.code_action()
		end, { buffer = buf, desc = "lsp: show code actions"})

		map("n", "<leader>lrr", function()
			vim.lsp.buf.references()
		end, opts)

		map("n", "<leader>lrn", function()
			vim.lsp.buf.rename()
		end, opts)

		if client:supports_method("textDocument/signatureHelp") then
			map("n", "<C-s>", function()
				vim.lsp.buf.signature_help()
			end, opts)
		end

		map("n", "<leader>ln", function()
			vim.lsp.buf.goto_next()
		end, { buffer=buf, desc="lsp: go to next diagnostic"})

		map("n", "<leader>lp", function()
			vim.lsp.buf.goto_prev()
		end, { buffer = buf, desc="lsp: go to previous diagnostic"})

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

		-- map("n", "<leader>ld", function() vim.lsp.buf.open_float() end, { buffer = buf, desc = "lsp: open float" })
		-- map("n", "<leader>lof", function() vim.lsp.buf.open_float() end, { buffer = buf, desc = "lsp: open float" })
        --
        vim.notify(client.name .. " attached to buffer")

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

-- trouble: only open when there's something that will crash the program
-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
-- 	callback = function(args)
-- 		local bufnr = args.buf
-- 		local errors = vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
-- 		if errors ~= nil and #errors > 0 then
-- 			require("trouble").open({
-- 				mode = "diagnostics",
-- 				filter = { buf = 0 },
-- 				focus = false,
-- 				pinned = true,
-- 			})
-- 		end
-- 	end,
-- })

-- trouble: close when closing buffer
local trouble = require("trouble")

local function view_is_for(bufnr)
	if not trouble.is_open() then
		return false
	end
	local items = trouble.get_items()

	return #items > 0 and items[1].buf == bufnr
end

local function maybe_close_trouble(bufnr)
	if view_is_for(bufnr) then
		vim.schedule(function()
			pcall(trouble.close)
		end)
	end
end

-- call :q / window close
vim.api.nvim_create_autocmd("WinClosed", {
	callback = function(args)
		local win = tonumber(args.match)
		if win == nil then
			vim.notify("cmds.lua WinClosed autocmd - could not convert " .. args.match .. " to a number")
			return
		end
		local buf = vim.api.nvim_win_get_buf(win)
		maybe_close_trouble(buf)
	end,
})

-- buffer delete
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
	callback = function(args)
		maybe_close_trouble(args.buf)
	end,
})

-- editor quit
vim.api.nvim_create_autocmd("QuitPre", {
	callback = function()
		-- local trouble = require("trouble")
		if trouble.is_open() then
			pcall(trouble.close)
		end
	end,
})

-- use zen to open urls
local _orig_open = vim.ui.open

vim.ui.open = function(input, opts)
    local target = input or vim.fn.expand("<cfile>")

    if target:match("^[%a][%w+,-]*://") then
        vim.fn.jobstart({ "firefox", target }, { detach = true })
    else
        return _orig_open(input, opts)
    end
end
