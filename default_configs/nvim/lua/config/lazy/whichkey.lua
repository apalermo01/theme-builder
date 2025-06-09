return {
	"folke/which-key.nvim",
	lazy = false,
	opts = {
		preset = "helix", -- classic | modern | helix
		keys = { -- scroll bindings inside the popup
			scroll_down = "<C-d>",
			scroll_up = "<C-u>",
		},

		-- v3 mapping spec
		spec = {
			------------------------------------------------------------------
			-- <space> …  (leader in the helix preset)
			------------------------------------------------------------------
			{ "<leader>b", group = "Buffers" }, -- <space>b
			{ "<leader>t", group = "Tabs" }, -- <space>t
			{ "<leader>v", group = "LSP" }, -- <space>v
			{ "<leader>d", group = "Debug" }, -- <space>d
			{ "<leader>p", group = "Pickers" }, -- <space>p
			{ "<leader>c", group = "Code" }, -- <space>c
			{ "<leader>g", group = "Git" }, -- <space>g
			{ "<leader>h", group = "Harpoon" }, -- <space>h
			{ "<leader>o", group = "Obsidian" }, -- <space>o

			------------------------------------------------------------------
			-- <space><space>… (double-leader)
			------------------------------------------------------------------
			{ "<Space>t", group = "Terminal" }, -- <space><space>t
		},
	},
}
