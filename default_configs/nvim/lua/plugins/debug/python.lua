return {

	{
		"mfussenegger/nvim-dap-python",
		config = function()

			local dap = require("dap")
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						return "/usr/bin/python"
					end,
				},
			}
			require("dap-python").setup("python")
			-- if vim.fn.has("win32") == 1 then
			-- 	require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
			-- else
			-- 	require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/bin/python"))
			-- end
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		optional = true,
		opts = function(_, opts)
			opts.auto_brackets = opts.auto_brackets or {}
			table.insert(opts.auto_brackets, "python")
		end,
	},
}
