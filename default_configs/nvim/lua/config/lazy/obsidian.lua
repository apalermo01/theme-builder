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
        disable_frontmatter = false,
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
        { "<leader>oo",  ":cd " .. OBSIDIAN_NOTES_DIR .. "<CR>", "n", desc = "jump to notes directory" },
        {
            "<leader>on",
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
            desc = "New technical note",
        },
    },
}
