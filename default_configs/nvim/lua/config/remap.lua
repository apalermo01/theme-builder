vim.g.mapleader = " "

map("n", "<leader>ex", vim.cmd.Ex)

-- Newlines above and below
map("n", "oo", "o<Esc>k")
map("n", "OO", "O<Esc>j")

-- tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>")
map("n", "<leader>t<leader", "<cmd>tabnext<cr>")
map("n", "<leader>tm", "<cmd>tabmove<cr>")
map("n", "<leader>tc", "<cmd>tabclose<cr>")
map("n", "<leader>to", "<cmd>tabonly<cr>")

-- buffers
map("n", "<leader>bN", "<cmd>enew<CR>", { desc = "new buffer" })
map("n", "<leader>x", function() require("bufdelete").bufdelete(0, true) end, { desc = "delete this buffer" })
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "next buffer", silent = true })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "previous buffer", silent = true })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

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

map("n", "<Esc>", CloseFloatingOrClearHighlight, { noremap = true, silent = true })

-- terminal
map("n", "<leader>tr", "<cmd>tabnew | term<CR>", { desc = "open terminal in new tab" })

-- movement
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-f>", "<C-f>zz")
map("n", "<C-b>", "<C-b>zz")

map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")

-- https://www.youtube.com/watch?v=w7i4amO_zaE
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "J", "mzJ`z")

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("x", "<leader>p", "\"_dP")

-- yank to system clipboard without any gymnastics
map("n", "<leader>y", "\"+y")
map("n", "<leader>y", "\"+y")
map("n", "<leader>Y", "\"+y")
map("n", "<leader>p", "\"+p")
map("n", "<leader>p", "\"+p")
map("n", "<leader>P", "\"+p")

map("i", "<C-c>", "<Esc>")

-- TODO: set up tmux sessionizer

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")

-- obsidian stuff
map("n", "<leader>ont",
    function()
        local input = vim.fn.input("new note name (technical): ")
        if input == "" then
            print("Expected an argument!")
            return
        end

        local formatted_name = os.date("%Y-%m-%d") .. "_" .. input:gsub(" ", "-") .. ".md"
        local notes_path = os.getenv("NOTES_PATH") or "~/notes/"
        local full_path = notes_path .. "/0-notes/0-notes/0-inbox/" .. formatted_name
        vim.cmd("edit " .. full_path)
    end,
    { desc = "create a new technical note" }
)

map("n", "<leader>onp",
    function()
        local input = vim.fn.input("new note name: ")
        if input == "" then
            print("Expected an argument!")
            return
        end

        local formatted_name = os.date("%Y-%m-%d") .. "_" .. input:gsub(" ", "-") .. ".md"
        local notes_path = os.getenv("NOTES_PATH") or "~/notes"
        local full_path = notes_path .. "/0-notes/1-private/0-inbox/" .. formatted_name
        vim.cmd("edit " .. full_path)
    end,
    { desc = "create a new personal note" }
)
-- these overwrite harpoon keybindings. Need to figure out where to remap these
-- map("n", "<leader>k", "<cmd>lnext<CR>zz")
-- map("n", "<leader>j", "<cmd>lprev<CR>zz")
