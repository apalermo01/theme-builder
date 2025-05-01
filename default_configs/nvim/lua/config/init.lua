require("config.remap")
require("config.opts")
require("config.lazy_init")

local augroup = vim.api.nvim_create_augroup

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

-- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
--     pattern = "*.md",
--     callback = function()
--         local line = vim.api.nvim_get_current_line()
--         if line:match("^#+%s") then
--             vim.lsp.buf.rename()
--         end
--     end,
--     desc = "Call lsp rename when renaming a header in a markdown file"
-- })

vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25


-- Automatic file / heading renaming
local function get_vault_root(fname)
    local paths = {
        "0-technical-notes",
        "1-notes",
    }
    for _, sub in ipairs(paths) do
        local full = OBSIDIAN_NOTES_DIR .. "/" .. sub
        if fname:find(full, 1, true) then return full end
    end
    return vim.fn.getcwd()
end

-- require("default_configs.nvim.lua.config.lazy.lsp.lsp-base").markdown_oxide.setup({
--     capabilities = capabilities,
--     root_dir = function(fname)
--         return get_vault_root(fname)
--     end,
-- })
