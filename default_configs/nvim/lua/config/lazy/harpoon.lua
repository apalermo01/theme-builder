return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2", 
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require('harpoon')
		harpoon:setup()

		map("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
		map("n", "<leader>a", function() harpoon:list():add() end)

		map("n", "<leader>h", function() harpoon:list():select(1) end)
		map("n", "<leader>j", function() harpoon:list():select(2) end)
		map("n", "<leader>k", function() harpoon:list():select(3) end)
		map("n", "<leader>l", function() harpoon:list():select(4) end)
		map("n", "<leader>;", function() harpoon:list():select(5) end)

		map("n", "<leader><leader>h", function()
            harpoon:list():replace_at(1)
            vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 1")
        end)

		map("n", "<leader><leader>j", function()
            harpoon:list():replace_at(2)
            vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 2")
        end)

		map("n", "<leader><leader>k", function()
            harpoon:list():replace_at(3)
            vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 3")
        end)
        
		map("n", "<leader><leader>l", function()
            harpoon:list():replace_at(4)
            vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 4")
        end)

		map("n", "<leader><leader>;", function()
            harpoon:list():replace_at(5)
            vim.notify("added " .. vim.fn.expand("%:h") .. " to harpoon 5")
        end)

		map("n", "<C-S-P>", function() harpoon:list():prev() end)
		map("n", "<C-S-N>", function() harpoon:list():next() end)

	end
}
