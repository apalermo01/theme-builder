-- https://www.youtube.com/watch?v=1Lmyh0YRH-w
-- https://github.com/zazencodes/dotfiles/blob/main/nvim/lua/workflows.lua
--
return {
    "epwalsh/obsidian.nvim",
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
    },

    opts = {
        ui = {
            enable = false,
        },
        workspaces = {
            {
                name = "notes",
                path = OBSIDIAN_NOTES_DIR,
                overrides = {
                    notes_subdir = "0-notes/unsorted"
                },
            },
        },
        disable_frontmatter = true,
        templates = {
            folder = OBSIDIAN_TEMPLATE_FOLDER,
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
        },
        new_notes_location = "current_dir",
        notes_subdir = OBSIDIAN_NOTES_SUBDIR,

        note_id_func = function(title)
            local suffix = ""
            if title ~= nil then
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                print("Invalid new note name - must have a title")
            end

            return suffix
        end,
    },

    keys = {
        { "<leader>ond",  ":cd " .. OBSIDIAN_NOTES_DIR .. "<CR>", "n", desc = "jump to notes directory" },
        {
            "<leader>onf",
            function()
                local current_file = vim.fn.expand("%:p")
                if string.find(current_file, OBSIDIAN_NOTES_DIR, 1, true) then
                    vim.cmd("ObsidianTemplate note")
                else
                    print("Cannot format file- not in notes directory")
                end
            end,
            "n",
            desc = "format current file as a note",
        },

        { "<leader>obl", "<cmd>ObsidianBacklinks<CR>",           "n", desc = "show backlinks in telescope" },

        {
            "<leader>okt",
            ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-notes/0-notes/1-zettelkasten<cr>:bd<CR>",
            "n",
            desc = "move to technical notes",
        },
        {
            "<leader>okp",
            ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-notes/1-private/1-zettelkasten<cr>:bd<CR>",
            "n",
            desc = "move to personal notes",
        },
        {
            "<leader>ost",
            ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-notes/0-notes/2-source-material<cr>:bd<CR>",
            "n",
            desc = "move to source material (technical notes)",
        },
        {
            "<leader>osp",
            ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-notes/1-private/2-source-material<cr>:bd<CR>",
            "n",
            desc = "move to source material",
        },
        {
            "<leader>ott",
            ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-notes/0-notes/3-tags<cr>:bd<CR>",
            "n",
            desc = "move to tags (normal)",
        },
        {
            "<leader>otp",
            ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-notes/1-private/3-tags<cr>:bd<CR>",
            "n",
            desc = "move to tags (private)",
        },
        {
            "<leader>ort",
            ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-notes/0-notes/4-rough-notes<cr>:bd<CR>",
            "n",
            desc = "move to rough nots (normal)",
        },
        {
            "<leader>orp",
            ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/0-notes/1-private/4-rough-notes<cr>:bd<CR>",
            "n",
            desc = "move to rough notes (private)",
        },
        {
            "<leader>odd",
            ":!rm '%:p'<CR>:bd<CR>",
            "n",
            desc = "delete note",
        },
        {
            "<leader>ont",
            function()
                local input = vim.fn.input("new note name: ")
                if input == "" then
                    print("Expected an argument!")
                    return
                end

                local formatted_name = os.date("%Y-%m-%d") .. "_" .. input:gsub(" ", "-") .. ".md"
                local notes_path = os.getenv("NOTES_PATH") or "~/notes"
                local full_path = notes_path .. "/0-notes/0-notes/0-inbox/" .. formatted_name
                vim.cmd("edit " .. full_path)
            end,
            -- ":!mv '%:p' " .. OBSIDIAN_NOTES_DIR .. "/1-notes/2-source-material<cr>:bd<CR>",
            "n",
            desc = "New note in normal folder",
        },
        {
            "<leader>onp",
            function()
                local input = vim.fn.input("new note name: ")
                if input == "" then
                    print("Expected an argument!")
                    return
                end

                local formatted_name = os.date("%Y-%m-%d") .. "_" .. input:gsub(" ", "-") .. ".md"
                local notes_path = os.getenv("NOTES_PATH") or "~/notes"
                local full_path = notes_path .. "/0-notes/1-private/0-inbox/" .. formatted_name
                vim.cmd("edit " .. full_path)
            end,
            "n",
            desc = "New note in private folder",
        },
		{
			"<leader>oo",
			function()
				local vault_root = os.getenv("NOTES_PATH") -- "/home/alex/Documents/git/notes"
				local vault_name = vim.fn.fnamemodify(vault_root, ":t") -- "notes"
				local function urlencode(str)
					return (
						str:gsub("([^%w%-_%.~])", function(c)
							return string.format("%%%02X", string.byte(c))
						end)
					)
				end

				local abs = vim.fn.expand("%:p") -- full path of current buffer
				if not vim.startswith(abs, vault_root) then
					vim.notify("File is not inside your Obsidian vault", vim.log.levels.WARN)
					return
				end

				local rel = abs:sub(#vault_root + 2) -- strip "/…/notes/"
				local uri = ("obsidian://open?vault=%s&file=%s"):format(vault_name, urlencode(rel))

				-- use Neovim's non-blocking launcher instead of os.execute/nohup
				vim.system({ "obsidian", uri }, { detach = true })
			end,
			"n",
			desc = "open current file in obsidian",
		},
    },
}
