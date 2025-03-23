local client = vim.lsp.start_client {
    name = "educationalsp",
    cmd = { "/home/alex/Documents/git/educationalsp/main"},
}

-- if not client then 
--     vim.notify
