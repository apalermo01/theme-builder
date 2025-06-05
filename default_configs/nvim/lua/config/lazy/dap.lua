-- this is pulled straight from the config for lazyvim:
-- https://www.lazyvim.org/extras/dap/core
-- additional resource: https://www.youtube.com/watch?v=fvRwG17XsaA

return {
	{
		"mfussenegger/nvim-dap",
		recommended = true,
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},
		config = function()
			-- load mason-nvim-dap here, after all adapters have been setup
			-- if LazyVim.has("mason-nvim-dap.nvim") then
			-- 	require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
			-- end

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			-- for name, sign in pairs(LazyVim.config.icons.dap) do
			-- 	sign = type(sign) == "table" and sign or { sign }
			-- 	vim.fn.sign_define(
			-- 		"Dap" .. name,
			-- 		{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
			-- 	)
			-- end

			-- setup dap config by VsCode launch.json file
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		-- virtual text for the debugger
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},
	{ "nvim-neotest/nvim-nio" },
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = "mason.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
                "hadolint",
                "debugpy",
                "node-debug2-adapter",
                "js-debug-adapter",


				-- Update this to ensure that you have the debuggers for the langs you want
			},
		},
		-- mason-nvim-dap is loaded when nvim-dap loads
		config = function() end,
	},
}
