return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "ninja", "rst" } },
	},
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	opts = function(_, opts)
	-- 		local servers = { "pyright", "basedpyright", "ruff", "ruff_lsp"}
	-- 		for _, server in ipairs(servers) do
	-- 			opts.servers[server] = opts.servers[server] or {}
	-- 			-- opts.servers[server].enabled = server == lsp or server == ruff
	-- 		end
	-- 	end,
	-- },
}
