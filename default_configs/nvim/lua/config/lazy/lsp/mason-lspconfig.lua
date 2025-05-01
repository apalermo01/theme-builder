local cmp_lsp = require("cmp_nvim_lsp")
local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

return {
	"williamboman/mason-lspconfig.nvim",
	opts = {

		automatic_installation = not nixos,
		ensure_installed = nixos and {
			"lua_ls",
			"html",
			"cssls",
			"clangd",
			"pyright",
			"tsserver",
			"jsonls",
			"nil_ls",
			"bashls",
		} or {
			"lua_ls",
			"html",
			"cssls",
			"clangd",
			"pyright",
			"tsserver",
			"jsonls",
			"nil_ls",
			"markdown_oxide",
			"bashls",
		},

		handlers = {
			function(server_name)
				require("default_configs.nvim.lua.config.lazy.lsp.lsp-base")[server_name].setup({
					capabilities = capabilities,
				})
			end,

			["lua_ls"] = function()
				require("default_configs.nvim.lua.config.lazy.lsp.lsp-base").lua_ls.setup({
					cmd = nixos and { "lua-language-server" } or nil,
					capabilities = capabilities,
				})
			end,

			["markdown_oxide"] = function()
				require("default_configs.nvim.lua.config.lazy.lsp.lsp-base").markdown_oxide.setup({
					cmd = nixos and { "markdown-oxide" } or nil,
					capabilities = vim.tbl_deep_extend("force", capabilities, {
						workspace = {
							didChangeWatchedFiles = {
								dynamicRegistration = true,
							},
						},
					}),
	                root_dir = function(fname)
	                    local paths = {
	                    	"0-technical-notes",
	                    	"1-notes",
	                    }
	                    for _, sub in ipairs(paths) do
	                    	local full = OBSIDIAN_NOTES_DIR .. "/" .. sub
	                    	if fname:find(full, 1, true) then
	                    		return full
	                    	end
	                    end
	                    return vim.fn.getcwd()


	                end,
				})
			end,

			["nil_ls"] = function()
				require("default_configs.nvim.lua.config.lazy.lsp.lsp-base").nil_ls.setup({
					autostart = true,
					settings = {
						["nil"] = {
							testSetting = 42,
							formatting = {
								command = { "nixfmt-rfc-style" },
							},
						},
					},
				})
			end,
		},
	},
}
