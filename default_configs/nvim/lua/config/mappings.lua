vim.g.mapleader = " "

-- top-level keys:
-- buffer operations:  <leader>b
-- tab operations:     <leader>t
--          exception: toggle trouble: <leader>tt
-- terminal operations: <leader><leader>t
-- lsp operations:     <leader>v
-- debug operatiosn:   <leader>d
-- telescope / picker: <leader>p
--          excepction: paste from clipboard: <leader>pc
-- formatting:         <leader>c
-- git:                <leader>g
-- harpoon / quick switching: <leader>h,j,k,l,;
--          -- do not use these keys for any other top level headers
-- obsidian            <leader>o
--          exception: show outline: <leader>ol

-----------------------------------------------------------------
-- functions
-----------------------------------------------------------------
-- use escape to clear highlights or close open windows
function CloseFloatingOrClearHighlight()
	local floating_wins = 0
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			floating_wins = floating_wins + 1
			vim.api.nvim_win_close(win, false)
		end
	end

	if floating_wins == 0 then
		vim.cmd("noh")
	end
end

-----------------------------------------------------------------
-- misc
-----------------------------------------------------------------

-- netrw
-- map("n", "<leader>ex", vim.cmd.Ex)

-- Newlines above and below without leaving normal mode
map("n", "oo", "o<Esc>k")
map("n", "OO", "O<Esc>j")

-- use escape to clear highlights and close floating windowns
map("i", "<C-c>", "<Esc>")
map("n", "<Esc>", CloseFloatingOrClearHighlight, { noremap = true, silent = true })

-- movement
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")

-- tmux
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")

-- https://www.youtube.com/watch?v=w7i4amO_zaE
-- move selected lines up/down in visualmode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- join lines without moving cursor
map("n", "J", "mzJ`z")

-- keep search matches centered
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- paste over visual selection wihout yanking it
map("x", "<leader>p", '"_dP')

-- yank to system clipboard without any gymnastics
map({ "v", "n" }, "<leader>yc", '"+y')
map({ "v", "n" }, "<leader>pc", '"+p')

-- TODO: set up tmux sessionizer

-- this does some kind of magic that I saw here:
-- https://www.youtube.com/watch?v=w7i4amO_zaE
-- however, I never use it, so I'm commenting it out for now
-- map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- quickfix navigation
-- TODO: this currently overlaps with tmux
-- map("n", "<C-k>", "<cmd>cnext<CR>zz")
-- map("n", "<C-j>", "<cmd>cprev<CR>zz")

-- spellcheck
map("n", "<leader>s", function()
	vim.wo.spell = not vim.wo.spell
end, { desc = "toggle spellcheck" })

-- file navigation
map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })

-- project navigation
map("n", "<leader>ol", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "toggle undo tree" })
map("n", "<leader>E", "<cmd>EditProjectConfig<CR>", { desc = "edit project config" })
-----------------------------------------------------------------
-- terminal
-----------------------------------------------------------------
map("n", "<leader><leader>tr", "<cmd>tabnew | term<CR>", { desc = "open terminal in new tab" })
map("n", "<leader><leader>tt", "<cmd>lua require('FTerm').toggle()<cr>", { desc = "toggle floating terminal" })
map(
	"t",
	"<leader><leader>tt",
	"<C-\\><C-n><cmd>lua require('FTerm').toggle()<cr>",
	{ desc = "toggle floating terminal" }
)

-----------------------------------------------------------------
-- tabs
-----------------------------------------------------------------
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "make new tab" })
map("n", "<leader>t<leader", "<cmd>tabnext<cr>", { desc = "go to next tab" })
map("n", "<leader>tm", "<cmd>tabmove<cr>", { desc = "move tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "close tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "tabonly" })

-----------------------------------------------------------------
-- buffers
-----------------------------------------------------------------
map("n", "<leader>bN", "<cmd>enew<CR>", { desc = "new buffer" })
map("n", "<leader>x", function()
	require("bufdelete").bufdelete(0, true)
end, { desc = "delete this buffer" })
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "next buffer", silent = true })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "previous buffer", silent = true })

-----------------------------------------------------------------
-- formatting <leader>c
-----------------------------------------------------------------
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })
map({ "n", "v" }, "<leader>cc", "<leader>/", { desc = "toggle comment", remap = true })
map("n", "<leader>cm", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

-----------------------------------------------------------------
-- debug
-----------------------------------------------------------------

-- trouble
map("n", "<leader>dt", function()
	require("trouble").toggle({
		mode = "diagnostics",
		filter = { buf = 0 },
		pinned = true,
		focus = false,
	})
end, { desc = "toggle trouble" })

map("n", "]t", function()
	require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "trouble: next diagnostic" })
map("n", "<leader>dn", function()
	require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "trouble: next diagnostic" })

map("n", "[t", function()
	require("trouble").previous({ skip_groups = true, jump = true })
end, { desc = "trouble: previous diagnostic" })
map("n", "<leader>dp", function()
	require("trouble").previous({ skip_groups = true, jump = true })
end, { desc = "trouble: previous diagnostic" })

-- Core nvim-dap keymaps
-- TODO: what is get_args?
-- map("n", "<leader>da", function()
--     require("dap").continue({ before = get_args })
-- end, { desc = "DAP: Run with args" })

map("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP: Breakpoint condition" })

map("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "DAP: Toggle breakpoint" })

map("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "DAP: Run/Continue" })

map("n", "<leader>dC", function()
	require("dap").run_to_cursor()
end, { desc = "DAP: Run to cursor" })

map("n", "<leader>dg", function()
	require("dap").goto_()
end, { desc = "DAP: Go to line (no execute)" })

map("n", "<leader>di", function()
	require("dap").step_into()
end, { desc = "DAP: Step into" })

map("n", "<leader>dj", function()
	require("dap").down()
end, { desc = "DAP: Down" })

map("n", "<leader>dk", function()
	require("dap").up()
end, { desc = "DAP: Up" })

map("n", "<leader>dl", function()
	require("dap").run_last()
end, { desc = "DAP: Run last" })

map("n", "<leader>do", function()
	require("dap").step_out()
end, { desc = "DAP: Step out" })

map("n", "<leader>dO", function()
	require("dap").step_over()
end, { desc = "DAP: Step over" })

map("n", "<leader>dP", function()
	require("dap").pause()
end, { desc = "DAP: Pause" })

map("n", "<leader>dr", function()
	require("dap").repl.toggle()
end, { desc = "DAP: Toggle REPL" })

map("n", "<leader>ds", function()
	require("dap").session()
end, { desc = "DAP: Session" })

map("n", "<leader>dx", function()
	require("dap").terminate()
end, { desc = "DAP: Terminate" })

map("n", "<leader>dw", function()
	require("dap.ui.widgets").hover()
end, { desc = "DAP: Widgets" })

-- nvim-dap-ui keymaps
map("n", "<leader>du", function()
	require("dapui").toggle({})
end, { desc = "DAP: Toggle UI" })

map({ "n", "v" }, "<leader>de", function()
	require("dapui").eval()
end, { desc = "DAP: Eval" })

-----------------------------------------------------------------
-- obsidian
-----------------------------------------------------------------
-- Jump to Obsidian notes directory
map(
	"n",
	"<leader>ond",
	":cd " .. (OBSIDIAN_NOTES_DIR) .. "<CR>",
	{ desc = "jump to notes directory" }
)

-- Format current file as Obsidian note (only if inside vault)
map("n", "<leader>onf", function()
	local current_file = vim.fn.expand("%:p")
	local vault = OBSIDIAN_NOTES_DIR
	if not current_file:find(vault, 1, true) then
		print("Cannot format file— not in notes directory")
		return
	end
	vim.cmd("ObsidianTemplate note")
end, { desc = "format current file as a note" })

-- Show backlinks via Telescope
map("n", "<leader>obl", "<cmd>ObsidianBacklinks<CR>", { desc = "show backlinks (Telescope)" })

-- Move current note to technical inbox
map(
	"n",
	"<leader>okt",
	":!mv '%:p' " .. (OBSIDIAN_NOTES_DIR) .. "/0-notes/0-notes/1-zettelkasten<CR>:bd<CR>",
	{ desc = "move to technical notes" }
)

-- Move current note to personal inbox
map(
	"n",
	"<leader>okp",
	":!mv '%:p' " .. (OBSIDIAN_NOTES_DIR) .. "/0-notes/1-private/1-zettelkasten<CR>:bd<CR>",
	{ desc = "move to personal notes" }
)

-- Move to source material (technical)
map(
	"n",
	"<leader>ost",
	":!mv '%:p' " .. (OBSIDIAN_NOTES_DIR) .. "/0-notes/0-notes/2-source-material<CR>:bd<CR>",
	{ desc = "move to source material (technical)" }
)

-- Move to source material (private)
map(
	"n",
	"<leader>osp",
	":!mv '%:p' " .. (OBSIDIAN_NOTES_DIR) .. "/0-notes/1-private/2-source-material<CR>:bd<CR>",
	{ desc = "move to source material (private)" }
)

-- Move to tags (normal)
map(
	"n",
	"<leader>ott",
	":!mv '%:p' " .. (OBSIDIAN_NOTES_DIR) .. "/0-notes/0-notes/3-tags<CR>:bd<CR>",
	{ desc = "move to tags (normal)" }
)

-- Move to tags (private)
map(
	"n",
	"<leader>otp",
	":!mv '%:p' " .. (OBSIDIAN_NOTES_DIR) .. "/0-notes/1-private/3-tags<CR>:bd<CR>",
	{ desc = "move to tags (private)" }
)

-- Move to rough notes (normal)
map(
	"n",
	"<leader>ort",
	":!mv '%:p' " .. (OBSIDIAN_NOTES_DIR) .. "/0-notes/0-notes/4-rough-notes<CR>:bd<CR>",
	{ desc = "move to rough notes (normal)" }
)

-- Move to rough notes (private)
map(
	"n",
	"<leader>orp",
	":!mv '%:p' " .. (OBSIDIAN_NOTES_DIR) .. "/0-notes/1-private/4-rough-notes<CR>:bd<CR>",
	{ desc = "move to rough notes (private)" }
)

-- Delete current note
map("n", "<leader>odd", ":!rm '%:p'<CR>:bd<CR>", { desc = "delete note" })

-- Create a new note in the technical inbox
map("n", "<leader>ont", function()
	local input = vim.fn.input("new note name: ")
	if input == "" then
		print("Expected an argument!")
		return
	end
	local formatted_name = os.date("%Y-%m-%d") .. "_" .. input:gsub(" ", "-") .. ".md"
	local notes_path = OBSIDIAN_NOTES_DIR
	local full_path = notes_path .. "/0-notes/0-notes/0-inbox/" .. formatted_name
	vim.cmd("edit " .. full_path)
end, { desc = "New note in normal folder" })

-- Create a new note in the private inbox
map("n", "<leader>onp", function()
	local input = vim.fn.input("new note name: ")
	if input == "" then
		print("Expected an argument!")
		return
	end
	local formatted_name = os.date("%Y-%m-%d") .. "_" .. input:gsub(" ", "-") .. ".md"
	local notes_path = OBSIDIAN_NOTES_DIR
	local full_path = notes_path .. "/0-notes/1-private/0-inbox/" .. formatted_name
	vim.cmd("edit " .. full_path)
end, { desc = "New note in private folder" })

-- Open current file in the Obsidian app (requires `obsidian` CLI in PATH)
map("n", "<leader>oo", function()
	local vault_root = OBSIDIAN_NOTES_DIR
	local vault_name = vim.fn.fnamemodify(vault_root, ":t")
	local function urlencode(str)
		return str:gsub("([^%w%-_%.~])", function(c)
			return string.format("%%%02X", string.byte(c))
		end)
	end

	local abs = vim.fn.expand("%:p")
	if not vim.startswith(abs, vault_root) then
		vim.notify("File is not inside your Obsidian vault", vim.log.levels.WARN)
		return
	end

	local rel = abs:sub(#vault_root + 2)
	local uri = ("obsidian://open?vault=%s&file=%s"):format(vault_name, urlencode(rel))

	vim.system({ "obsidian", uri }, { detach = true })
end, { desc = "open current file in Obsidian" })

--------------------------------------------------------------------------------
-- TELESCOPE (pickers) (<leader>p prefix)
--------------------------------------------------------------------------------
local builtin = require("telescope.builtin")

-- Find all files (hidden + no ignore)
map("n", "<leader>pa", function()
	builtin.find_files({ hidden = true, no_ignore = true })
end, { desc = "Telescope: find all files" })

-- File browser
map("n", "<leader>pbb", "<cmd>Telescope file_browser<CR>", { desc = "Telescope: file browser" })

-- Search open buffers
map("n", "<leader>pbu", builtin.buffers, { desc = "Telescope: search open buffers" })

-- Find files
map("n", "<leader>pf", builtin.find_files, { desc = "Telescope: find files" })

-- Live grep
map("n", "<leader>pg", builtin.live_grep, { desc = "Telescope: live grep" })

-- git history
map("n", "<leader>ph", builtin.git_bcommits, { desc = "Telescope: commit history" })

-- Jumplist
map("n", "<leader>pj", builtin.jumplist, { desc = "Telescope: jumplist" })

-- List marks
map("n", "<leader>pma", builtin.marks, { desc = "Telescope: list marks" })

-- List man pages
map("n", "<leader>pmp", builtin.man_pages, { desc = "Telescope: list man pages" })

-- Search old files
map("n", "<leader>po", builtin.oldfiles, { desc = "Telescope: search old files" })

-- Resume last picker
map("n", "<leader>pr", builtin.resume, { desc = "Telescope: resume last picker" })

-- Spell suggestions
map("n", "<leader>pss", builtin.spell_suggest, { desc = "Telescope: spell suggest" })

-- List registers
map("n", '<leader>p"', builtin.registers, { desc = "Telescope: list registers" })

-- Prompted grep for a string
map("n", "<leader>pw", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Telescope: search for a string" })

--------------------------------------------------------------------------------
-- LSP MAPS (<leader>v prefix)
--------------------------------------------------------------------------------
-- Create an augroup for LSP keymaps
local lsp_group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(e)
		local buf = e.buf
		local client = assert(vim.lsp.get_client_by_id(e.data.client_id))
		local opts = { buffer = buf }

		-- Go to definition (normal and <leader>vd)
		map("n", "<leader>vd", function()
			vim.lsp.buf.definition()
		end, vim.tbl_extend("force", opts, { desc = "LSP: go to definition" }))

		-- Hover
		map("n", "K", function()
			vim.lsp.buf.hover()
		end, vim.tbl_extend("force", opts, { desc = "LSP: hover" }))

		-- Show diagnostic in floating
		map("n", "<leader>vk", function()
			vim.diagnostic.open_float()
		end, vim.tbl_extend("force", opts, { desc = "LSP: show diagnostic" }))

		-- Workspace symbols
		map("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, vim.tbl_extend("force", opts, { desc = "LSP: workspace symbols" }))

		-- Code actions
		map("n", "<leader>va", function()
			vim.lsp.buf.code_action()
		end, vim.tbl_extend("force", opts, { desc = "LSP: code actions" }))

		-- References
		map("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, vim.tbl_extend("force", opts, { desc = "LSP: references" }))

		-- Rename
		map("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, vim.tbl_extend("force", opts, { desc = "LSP: rename" }))

		-- Signature help (if supported)
		if client.supports_method("textDocument/signatureHelp") then
			map("n", "<C-s>", function()
				vim.lsp.buf.signature_help()
			end, vim.tbl_extend("force", opts, { desc = "LSP: signature help" }))
		end

		-- Go to next/prev diagnostic
		map("n", "<leader>vn", function()
			vim.lsp.buf.goto_next()
		end, vim.tbl_extend("force", opts, { desc = "LSP: next diagnostic" }))
		map("n", "]l", function()
			vim.lsp.buf.goto_next()
		end, { buffer = buf, desc = "LSP: next diagnostic" })

		map("n", "<leader>vp", function()
			vim.lsp.buf.goto_prev()
		end, vim.tbl_extend("force", opts, { desc = "LSP: previous diagnostic" }))
		map("n", "[l", function()
			vim.lsp.buf.goto_prev()
		end, { buffer = buf, desc = "LSP: previous diagnostic" })

		-- telescope keybindings
		map("n", "<leader>plr", builtin.lsp_references, { desc = "lsp references" })
		map("n", "<leader>pli", builtin.lsp_implementations, { desc = "lsp implementations" })
		map("n", "<leader>pld", builtin.lsp_definitions, { desc = "lsp definitions" })

		-- Special markdown_oxide handling (Obsidian)
		if client.name == "markdown_oxide" then
			map("n", "<leader>vrn", function()
				local file = vim.api.nvim_buf_get_name(0)
				local vault = OBSIDIAN_NOTES_DIR
				if not file:find(vault, 1, true) then
					vim.notify("Not in an Obsidian vault. Rename aborted.", vim.log.levels.WARN)
					return
				end
				vim.lsp.buf.rename()
			end, vim.tbl_extend("force", opts, { desc = "LSP: safe rename" }))

			map("n", "gf", function()
				vim.lsp.buf.definition()
			end, vim.tbl_extend("force", opts, { desc = "LSP: go to definition" }))

			-- Backlinks (list references)
			map("n", "obl", function()
				vim.lsp.buf.references()
			end, vim.tbl_extend("force", opts, { desc = "LSP: Obsidian backlinks" }))
		end

		vim.notify(client.name .. " attached to buffer")
	end,
})

--------------------------------------------------------------------------------
-- git (<leader>g prefix)
--------------------------------------------------------------------------------
map("n", "<leader>gs", vim.cmd.Git, { desc = "start git fugitive" })

-- git history
map("n", "<leader>gh", builtin.git_bcommits, { desc = "Telescope: commit history" })

--------------------------------------------------------------------------------
-- harpoon
--------------------------------------------------------------------------------
local harpoon = require("harpoon")
map("n", "<leader>e", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "show harpoon list" })
map("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "harpoon add" })

map("n", "<leader>h", function()
	harpoon:list():select(1)
end, { desc = "harpoon(1)" })
map("n", "<leader>j", function()
	harpoon:list():select(2)
end, { desc = "harpoon(2)" })
map("n", "<leader>k", function()
	harpoon:list():select(3)
end, { desc = "harpoon(3)" })
map("n", "<leader>l", function()
	harpoon:list():select(4)
end, { desc = "harpoon(4)" })
map("n", "<leader>;", function()
	harpoon:list():select(5)
end, { desc = "harpoon(5)" })
map("n", "<leader>'", function()
	harpoon:list():select(5)
end, { desc = "harpoon(5)" })

map("n", "<leader><leader>h", function()
	harpoon:list():replace_at(1)
	vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 1")
end, { desc = "set current buffer to harpoon(1)" })

map("n", "<leader><leader>j", function()
	harpoon:list():replace_at(2)
	vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 2")
end, { desc = "set current buffer to harpoon(2)" })

map("n", "<leader><leader>k", function()
	harpoon:list():replace_at(3)
	vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 3")
end, { desc = "set current buffer to harpoon(3)" })

map("n", "<leader><leader>l", function()
	harpoon:list():replace_at(4)
	vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 4")
end, { desc = "set current buffer to harpoon(4)" })

map("n", "<leader><leader>;", function()
	harpoon:list():replace_at(5)
	vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 5")
end, { desc = "set current buffer to harpoon(5)" })

map("n", "<leader><leader>'", function()
	harpoon:list():replace_at(6)
	vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 6")
end, { desc = "set current buffer to harpoon(6)" })
