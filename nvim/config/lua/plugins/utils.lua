local event_presets = require("core.config").event_presets

return {
    -- https://github.com/nvim-neo-tree/neo-tree.nvim
    -- Neo-tree is a Neovim plugin to browse the file system and other tree like structures in whatever style suits you,
    -- including sidebars, floating windows, netrw split style, or all of them at once!
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        lazy = false, -- neo-tree will lazily load itself
        config = function()
            local git_status_icon = require("core.config").icon.git_status
            require("neo-tree").setup({
                -- fill any relevant options here
                close_if_last_window = false,
                enable_git_status = true,
                default_component_configs = {
                    git_status = {
                        symbols = {
                            -- Change type
                            added = git_status_icon.added, -- or "✚", but this is redundant info if you use git_status_colors on the name
                            modified = git_status_icon.modified, -- or "", but this is redundant info if you use git_status_colors on the name
                            deleted = git_status_icon.deleted, -- this can only be used in the git_status source
                            renamed = git_status_icon.renamed, -- this can only be used in the git_status source
                            -- Status type
                            untracked = git_status_icon.untracked,
                            ignored = git_status_icon.ignored,
                            unstaged = git_status_icon.unstaged,
                            staged = git_status_icon.staged,
                            conflict = git_status_icon.conflict,
                        },
                    },
                    window = {
                        position = "left",
                        width = 0.18,
                    },
                },
            })
            require("config.neo-tree")
        end,
        cmd = "Neotree",
    },

    -- https://github.com/echasnovski/mini.nvim
    -- Library of 40+ independent Lua modules improving overall Neovim (version 0.9 and higher) experience with minimal effort.
    -- They all share same configuration approaches and general design principles.
    {
        "echasnovski/mini.nvim",
        event = "VeryLazy",
        version = "*",
    },

    -- https://github.com/nvim-treesitter/nvim-treesitter-context
    -- nvim-treesitter-context: Lightweight alternative to context.vim
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            multiwindow = false, -- Enable multiwindow support.
            max_lines = 6, -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 3, -- Maximum number of lines to show for a single context
            trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
            -- Separator between context and content. Should be a single character string, like '-'.
            -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
            separator = nil,
            zindex = 20, -- The Z-index of the context window
            on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        },
        event = event_presets.start_edit,
    },

    -- https://github.com/akinsho/toggleterm.nvim
    -- toggleterm.nvim: A neovim plugin to persist and toggle multiple terminals during an editing session
    {
        "akinsho/toggleterm.nvim",
        event = event_presets.start_edit,
        version = "*",
        config = function()
            require("toggleterm").setup({})
            require("config.toggleterm")
        end,
    },

    -- https://github.com/nvim-telescope/telescope.nvim
    -- telescope.nvim: Gaze deeply into unknown regions using the power of the moon.
    {
        "nvim-telescope/telescope.nvim",
        -- branch = '0.1.x',
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        config = function()
            require("config.telescope")
        end,
    },

    --[[
    -- https://github.com/rcarriga/nvim-notify
    -- nvim-notify: A fancy, configurable, notification manager for NeoVim
    -- DISABLED for messages truncated when `max_width` set.
    {
        "rcarriga/nvim-notify",
        opts = {
            max_width = 30,
            max_height = 20,
            wrap_message = true,
        }
    },
    --]]

    -- https://github.com/folke/snacks.nvim
    -- snacks.nvim: A collection of small QoL plugins for Neovim.
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("snacks").setup({
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
                picker = { enabled = true },
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
            })
            require("config.snacks")
        end,
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
                    Snacks.picker.buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>eb",
                function()
                    Snacks.picker.buffers()
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
        },
        picker = {
            jump = {
                jumplist = true, -- save the current position in the jumplist
                tagstack = false, -- save the current position in the tagstack
                reuse_win = true, -- reuse an existing window if the buffer is already open
                close = true, -- close the picker when jumping/editing to a location (defaults to true)
                match = false, -- jump to the first match position. (useful for `lines`)
            },
        },
    },

    -- https://github.com/lewis6991/gitsigns.nvim
    -- gitsigns.nvim: Deep buffer integration for Git
    {
        "lewis6991/gitsigns.nvim",
        event = event_presets.start_edit,
        opts = {
            sign_priority = 100,
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    opts.noremap = true
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end)

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end)

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git stage current hunk" })
                map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git recover from staged hunk" })

                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }, { desc = "Git stage selected line" })
                end)

                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk(
                        { vim.fn.line("."), vim.fn.line("v") },
                        { desc = "Git recover selected line from staged" }
                    )
                end)

                map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git stage current file" })
                map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git recover from staged file" })
                map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git preview current hunk (float window)" })
                map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Git preview current hunk (inline)" })

                map("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end, { desc = "Git show blame of current line" })

                map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git show diff from staged" })

                map("n", "<leader>hD", function()
                    gitsigns.diffthis("~")
                end, { desc = "Git show diff from committed" })

                map("n", "<leader>hQ", function()
                    gitsigns.setqflist("all")
                end, { desc = "Show unstaged hunk list (all)" })
                map("n", "<leader>hq", gitsigns.setqflist, { desc = "Show unstaged hunk list (current file)" })

                -- Toggles
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle inline blame" })
                map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle highlight of changes (git)" })

                -- Text object
                map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk" })
            end,
        },
    },

    -- https://github.com/stevearc/overseer.nvim
    -- overseer.nvim: A task runner and job management plugin for Neovim
    {
        "stevearc/overseer.nvim",
        config = function()
            local opts = {
                strategy = "toggleterm",
            }
            require("overseer").setup(opts)
            vim.api.nvim_create_user_command("OverseerRestartLast", function()
                local overseer = require("overseer")
                local tasks = overseer.list_tasks({ recent_first = true })
                if vim.tbl_isempty(tasks) then
                    vim.notify("No tasks found", vim.log.levels.WARN)
                else
                    overseer.run_action(tasks[1], "restart")
                end
            end, {})

            vim.keymap.set("n", "<Leader>or", "<Cmd>OverseerRun<CR>", { noremap = true, desc = "Overseer run" })

            vim.keymap.set("n", "<Leader>oc", "<Cmd>OverseerRunCmd<CR>", { noremap = true, desc = "Overseer run cmd" })

            vim.keymap.set(
                "n",
                "<Leader>ot",
                "<Cmd>OverseerToggle<CR>",
                { noremap = true, desc = "Overseer toggle task list" }
            )
        end,
        event = event_presets.start_edit,
        version = "*",
    },
}
