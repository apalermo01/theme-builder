-- Lazy installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "config.lazy" },
        { import = "config.theme" },
        { import = "config.lazy.lsp" },
	},
	change_detection = { notify = false }
})

vim.notify = require('notify')

-- experimenting:
--
-- Lazy installation
-- local load_lazy = switchNix(function()
-- 	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- 	if not (vim.uv or vim.loop).fs_stat(lazypath) then
-- 		vim.fn.system({
-- 			"git",
-- 			"clone",
-- 			"--filter=blob:none",
-- 			"https://github.com/folke/lazy.nvim.git",
-- 			"--branch=stable", -- latest stable release
-- 			lazypath,
-- 		})
--
-- 		if vim.v.shell_error ~= 0 then
-- 			vim.api.nvim_echo({
-- 				{ "Failed to clone lazy.nvim\n", "ErrorMsg" },
-- 				{ out, "WarningMsg" },
-- 				{ "\nPress any key to exit..." },
-- 			}, true, {})
-- 			vim.fn.getchar()
-- 			os.exit(1)
-- 		end
-- 	end
--
-- 	vim.opt.rtp:prepend(lazypath)
-- end, function()
-- 	vim.opt.rtp:prepend([[lazy.nvim-plugin-path]])
-- end)
--
-- load_lazy()
--
-- require("lazy").setup({
-- 	spec = {
-- 		{ import = "config.lazy" },
-- 		{ import = "config.theme" },
-- 		{ import = "config.lazy.lsp" },
-- 	},
-- 	change_detection = { notify = false },
-- 	performance = {
-- 		rtp = {
-- 			reset = switchNix(true, false),
-- 		},
-- 	},
-- })
