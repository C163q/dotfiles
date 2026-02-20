local snacks_buffer_picker_cfg = {
    win = {
        input = {
            keys = {
                ["<C-d>"] = { "bufdelete", mode = { "i", "n" } },
            },
        },
        list = { keys = { ["<C-d>"] = "bufdelete" } },
    },
}

return {
    -- https://github.com/folke/snacks.nvim
    -- snacks.nvim: A collection of small QoL plugins for Neovim.
    {
        "folke/snacks.nvim",
        priority = 999,
        lazy = false,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = { enabled = true },
            indent = {
                enabled = true,
                indent = {
                    priority = 1,
                    enabled = true, -- enable indent guides
                    char = "│",
                    only_scope = false, -- only show indent guides of the scope
                    only_current = false, -- only show indent guides in the current window
                    hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
                },
                scope = {
                    enabled = true, -- enable highlighting the current scope
                    priority = 200,
                    char = "│",
                    underline = false, -- underline the start of the scope
                    only_current = false, -- only show scope in the current window
                    hl = { ---@type string|string[] hl group for scopes
                        "RainbowRed",
                        "RainbowYellow",
                        "RainbowBlue",
                        "RainbowOrange",
                        "RainbowGreen",
                        "RainbowViolet",
                        "RainbowCyan",
                    },
                },
            },
            input = { enabled = true },
            picker = {
                enabled = true,
                jump = {
                    jumplist = true, -- save the current position in the jumplist
                    tagstack = false, -- save the current position in the tagstack
                    reuse_win = true, -- reuse an existing window if the buffer is already open
                    close = true, -- close the picker when jumping/editing to a location (defaults to true)
                    match = false, -- jump to the first match position. (useful for `lines`)
                },
            },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { -- NOT good for using keyboard
                enabled = false,
            },
            statuscolumn = { -- override by nvim-ufo
                enabled = true,
                left = { "mark", "sign" },
                right = { "fold", "git" },
                git = {
                    -- patterns to match Git signs
                    patterns = { "GitSign", "MiniDiffSign" },
                },
                folds = {
                    open = true, -- show open fold icons
                    git_hl = true, -- use Git Signs hl for fold icons
                },
            },
            words = { enabled = true },
            lazygit = { enable = true },
            -- Can't use sixel for cost too much time rendering.
            --[[
            dashboard = {
                sections = {
                    {
                        section = "terminal",
                        cmd = "cat ~/custom/neovim/dashboard_ascii_art_1.txt; sleep .1s",
                        height = 14,
                        width = 30,
                        padding = 1,
                        indent = 20,
                    },
                    {
                        pane = 2,
                        { section = "header" },
                        { section = "keys", gap = 1, padding = 1 },
                        { section = "startup" },
                    },
                },
            }
            --]]
        },
        keys = {
            -- picker overwrite windows for winfixbuf is set!!!!!!
            -- May solve: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
            {
                "<leader>fF",
                function()
                    Snacks.picker.smart()
                end,
                desc = "Files Find (Smart)",
            },
            {
                "<leader>m",
                function()
                    Snacks.picker.buffers(snacks_buffer_picker_cfg)
                end,
                desc = "Buffers",
            },
            {
                "<leader>eb",
                function()
                    Snacks.picker.buffers(snacks_buffer_picker_cfg)
                end,
                desc = "Explore Buffers",
            },
            {
                "<leader>en",
                function()
                    Snacks.picker.notifications()
                end,
                desc = "Explore Notification History",
            },
            {
                "<leader>e:",
                function()
                    Snacks.picker.command_history()
                end,
                desc = "Explore Command History",
            },
            {
                "<leader>fg",
                function()
                    Snacks.picker.grep()
                end,
                desc = "File Grep",
            },
            {
                "<leader>fe",
                function()
                    Snacks.explorer()
                end,
                desc = "File Explorer",
            },
            {
                "<leader>gb",
                function()
                    Snacks.picker.git_branches()
                end,
                desc = "Picker: Git Branches",
            },
            {
                "<leader>gl",
                function()
                    Snacks.picker.git_log()
                end,
                desc = "Picker: Git Log",
            },
            {
                "<leader>gL",
                function()
                    Snacks.picker.git_log_line()
                end,
                desc = "Picker: Git Log Line",
            },
            {
                "<leader>gs",
                function()
                    Snacks.picker.git_status()
                end,
                desc = "Picker: Git Status",
            },
            {
                "<leader>gS",
                function()
                    Snacks.picker.git_stash()
                end,
                desc = "Picker: Git Stash",
            },
            {
                "<leader>gd",
                function()
                    Snacks.picker.git_diff()
                end,
                desc = "Picker: Git Diff (Hunks)",
            },
            {
                "<leader>go",
                function()
                    Snacks.picker.git_log_file()
                end,
                desc = "Picker: Git Log File",
            },
            {
                "gd",
                function()
                    Snacks.picker.lsp_definitions()
                end,
                desc = "Go to Definition",
            },
            {
                "gD",
                function()
                    Snacks.picker.lsp_declarations()
                end,
                desc = "Go to Declaration",
            },
            {
                "gR",
                function()
                    Snacks.picker.lsp_references()
                end,
                nowait = true,
                desc = "Go to References",
            },
            {
                "gI",
                function()
                    Snacks.picker.lsp_implementations()
                end,
                desc = "Go to Implementation",
            },
            {
                "gy",
                function()
                    Snacks.picker.lsp_type_definitions()
                end,
                desc = "Go to T[y]pe Definition",
            },
            {
                '<leader>e"',
                function()
                    Snacks.picker.registers()
                end,
                desc = "Explore Registers",
            },
            {
                "<leader>e/",
                function()
                    Snacks.picker.search_history()
                end,
                desc = "Explore Search History",
            },
            {
                "<leader>ea",
                function()
                    Snacks.picker.autocmds()
                end,
                desc = "Explore Autocmds",
            },
            {
                "<leader>eC",
                function()
                    Snacks.picker.commands()
                end,
                desc = "Explore Commands",
            },
            {
                "<leader>ed",
                function()
                    Snacks.picker.diagnostics()
                end,
                desc = "Explore Diagnostics",
            },
            {
                "<leader>eD",
                function()
                    Snacks.picker.diagnostics_buffer()
                end,
                desc = "Explore Buffer Diagnostics",
            },
            {
                "<leader>eh",
                function()
                    Snacks.picker.help()
                end,
                desc = "Explore Help Pages",
            },
            {
                "<leader>eH",
                function()
                    Snacks.picker.highlights()
                end,
                desc = "Explore Highlights",
            },
            {
                "<leader>ej",
                function()
                    Snacks.picker.jumps()
                end,
                desc = "Explore Jump Stack",
            },
            {
                "<leader>ek",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Explore Keymaps",
            },
            {
                "<leader>el",
                function()
                    Snacks.picker.loclist()
                end,
                desc = "Explore Location List",
            },
            {
                "<leader>li",
                function()
                    Snacks.picker.qflist()
                end,
                desc = "Picker: Quickfix List",
            },
            {
                "<leader>fr",
                function()
                    Snacks.picker.resume()
                end,
                desc = "Resume Last Picker",
            },
            {
                "<leader>eu",
                function()
                    Snacks.picker.undo()
                end,
                desc = "Explore Undo History",
            },
            {
                "<leader>es",
                function()
                    Snacks.picker.lsp_symbols()
                end,
                desc = "Explore LSP Symbols",
            },
            {
                "<leader>eS",
                function()
                    Snacks.picker.lsp_workspace_symbols()
                end,
                desc = "Explore LSP Workspace Symbols",
            },
            {
                "<leader>fb",
                function()
                    Snacks.picker.lines()
                end,
                desc = "File Buffer Lines",
            },
            {
                "<leader>fc",
                function()
                    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
                end,
                desc = "Find Config File",
            },
            {
                "<leader>ff",
                function()
                    Snacks.picker.files()
                end,
                desc = "Find Files",
            },
            {
                "<leader>gf",
                function()
                    Snacks.picker.git_files()
                end,
                desc = "Picker: Git Find Files",
            },
            {
                "<leader>ep",
                function()
                    Snacks.picker.projects()
                end,
                desc = "Explore and Open Projects",
            },
            {
                "<leader>er",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Explore Recent",
            },
            {
                "<Leader>eM",
                function()
                    Snacks.picker.man()
                end,
                desc = "Explore System Manuals",
            },
            {
                "<Leader>gw",
                function()
                    Snacks.lazygit.open()
                end,
                noremap = true,
                desc = "Open lazygit",
            },
            {
                "<Leader>gg",
                function()
                    Snacks.lazygit.log()
                end,
                noremap = true,
                desc = "Open lazygit with log view",
            },
            {
                "<Leader>gG",
                function()
                    Snacks.lazygit.log_file()
                end,
                noremap = true,
                desc = "Open lazygit with current log",
            },
        },
    },
}
