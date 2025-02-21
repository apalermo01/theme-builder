-- filetype specific settings
function PythonSettings()
	vim.bo.tabstop = 4
	vim.bo.shiftwidth = 4
	vim.cmd([[set tw=120]])
    vim.cmd([[set foldmethod=indent]])
end

function MarkdownSettings()
	vim.cmd([[set tw=80]])
end

vim.cmd([[
augroup FileTypeSettings
    autocmd!
    autocmd BufEnter * lua if vim.bo.filetype == 'python' then PythonSettings() end
    autocmd BufEnter * lua if vim.bo.filetype == 'markdown' then MarkdownSettings() end
augroup end
]])
