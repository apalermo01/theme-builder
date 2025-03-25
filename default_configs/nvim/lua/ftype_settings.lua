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

-- function MarkdownSettings()
-- 	vim.bo.textwidth = 0 -- Disable standard textwidth handling
--
-- 	vim.cmd([[
--     augroup MarkdownFormat
--       autocmd!
--       autocmd BufWritePre *.md lua FormatMarkdown()
--     augroup END
--   ]])
-- end



-- function FormatMarkdown()
--   local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
--   local formatted_lines = {}
--
--   for _, line in ipairs(lines) do
--     if #line > 80 then  -- Only process lines longer than 80 characters
--       local current_line = ""
--       local original_line = line
--       local expanded_line = line:gsub("%[%[.-|([^%]]+)%]%]", "%1")  -- For length checking only
--
--       for word in expanded_line:gmatch("%S+") do
--         if #current_line + #word + 1 > 80 then
--           table.insert(formatted_lines, original_line:sub(1, #current_line))  -- Insert original text
--           original_line = original_line:sub(#current_line + 2)  -- Remove the inserted part from original
--           current_line = word
--         else
--           if #current_line > 0 then
--             current_line = current_line .. " " .. word
--           else
--             current_line = word
--           end
--         end
--       end
--
--       if #current_line > 0 then
--         table.insert(formatted_lines, original_line)  -- Add whatever remains of the original line
--       end
--     else
--       table.insert(formatted_lines, line)  -- Keep the original line if it's not too long
--     end
--   end
--
--   vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted_lines)
-- end

vim.cmd([[
augroup FileTypeSettings
    autocmd!
    autocmd BufEnter * lua if vim.bo.filetype == 'python' then PythonSettings() end
    autocmd BufEnter * lua if vim.bo.filetype == 'markdown' then MarkdownSettings() end
augroup end
]])
