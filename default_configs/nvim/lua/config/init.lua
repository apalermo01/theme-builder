require("config.remap")
require("config.opts")
require("config.lazy_init")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local group = augroup('config', {})

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

autocmd('LspAttach', {
    group = group,
    callback = function(e)
        local opts = { buffer = e.buf }
        map("n", "gd", function() vim.lsp.buf.definition() end, {buffer = e.buf, desc = "lsp: go to definition" })
        map("n", "K", function() vim.lsp.buf.hover() end,  {buffer = e.buf, desc = "lsp: hover"})
        map("n", "<leader>lws", function() vim.lsp.buf.workspace_symbol() end,{ buffer = e.buf, desc = "lsp: show workspace symbols"}  )
        map("n", "<leader>ld", function() vim.lsp.buf.open_float() end, { buffer = e.buf, desc = "lsp: open float" } )
        map("n", "<leader>lca", function() vim.lsp.buf.code_action() end, opts)
        map("n", "<leader>lrr", function() vim.lsp.buf.references() end, opts)
        map("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        map("n", "<C-s>", function() vim.lsp.buf.signature_help() end, opts)
        map("n", "[d", function() vim.lsp.buf.goto_next() end, opts)
        map("n", "]d", function() vim.lsp.buf.goto_prev() end, opts)
    end
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.md",
    callback = function()
        local path = vim.api.nvim_buf_get_name(0)
        if not string.find(path, "templates/note.md") then
            local current_date = os.date("%Y-%m-%d")
            local file = vim.fn.expand("%:p")
            local content = vim.fn.readfile(file)
            local in_frontmatter = false
            for i, line in ipairs(content) do
                if line:match("^---") then
                    in_frontmatter = true
                elseif line:match("^---") and in_frontmatter then
                    break
                end
                if line:match("^date_modified:*") and in_frontmatter then
                    content[i] = "date_modified: " .. current_date
                    break
                end
            end
            vim.fn.writefile(content, file)
            vim.cmd("edit!")
        end
    end,
})
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
