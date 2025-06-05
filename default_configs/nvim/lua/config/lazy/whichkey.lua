return {
	"folke/which-key.nvim",
	lazy = false,
	opts = {
		preset = "helix", -- classic, modern, or helix
		keys = {
			scroll_down = "<c-d>",
			scroll_up = "<c-u>",
		},
		spec = {
			-- Top-level <leader> groups
			["<leader>"] = {
				b = { name = "Buffers" },
				t = { name = "Tabs" },
				v = { name = "LSP" },
				d = { name = "Debug" },
				p = { name = "Pickers" },
				c = { name = "Code/Format" },
				g = { name = "Git" },
				h = { name = "Harpoon" },
				o = { name = "Obsidian" },
			},
			-- Double-leader → Terminal
			["<leader><leader>"] = {
				t = { name = "Terminal" },
			},
		},
	},
}
