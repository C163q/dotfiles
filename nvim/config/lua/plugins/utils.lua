local event_presets = require("core.config").event_presets
local git_status_icon = require("core.config").icon.git_status

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
        config = {
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
        },
        keys = {
            {
                "<C-Q>",
                function()
                    if vim.bo.filetype == "neo-tree" then
                        vim.cmd("Neotree toggle=true")
                    else
                        vim.cmd("Neotree")
                    end
                end,
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "Open neo-tree",
            },
            {
                "<C-Q>",
                "<Esc><Cmd>Neotree<CR>",
                mode = "i",
                noremap = true,
                desc = "Open neo-tree",
            },
        },
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

    -- https://github.com/akinsho/toggleterm.nvim
    -- toggleterm.nvim: A neovim plugin to persist and toggle multiple terminals during an editing session
    {
        "akinsho/toggleterm.nvim",
        event = event_presets.start_edit,
        cmd = "ToggleTerm",
        version = "*",
        opts = {},
        keys = {
            {
                -- Open terminal (not default) when press <Leader>t
                "<Leader>tt",
                ":ToggleTerm<CR>",
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "Open terminal (not default)",
            },
            {
                -- Open new terminal (not toggle) when press <Leader>\
                "<Leader>\\",
                '<Cmd>exe v:count1 . "ToggleTerm"<CR>',
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "Open terminal#n decided by number prefix",
            },
            {
                "<Leader>tS",
                "<Cmd>TermSelect<CR>",
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "Select Terminal with input",
            },
            {
                "<Leader>ts",
                '<Cmd>exe v:count1 . "TermSelect"<CR>',
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "Select #n terminal decided by number prefix",
            },
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

    -- https://github.com/folke/trouble.nvim
    -- Trouble: A pretty list for showing diagnostics, references, telescope results,
    -- quickfix and location lists to help you solve all the trouble your code is causing.
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>lx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Trouble: Diagnostics",
            },
            {
                "<leader>lX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Trouble: Buffer Diagnostics",
            },
            {
                "<leader>ls",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Trouble: Symbols",
            },
            {
                "<leader>ll",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "Trouble: LSP Definitions / references / ...",
            },
            {
                "<leader>lL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Trouble: Location List",
            },
            {
                "<leader>lQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Trouble: Quickfix List",
            },
        },
    },

    -- https://github.com/folke/persistence.nvim
    -- Persistence: Persistence is a simple lua plugin for automated session management.
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        keys = {
            {
                "<leader>sl",
                function()
                    require("persistence").load()
                end,
                desc = "Load Session for current dir",
            },
            {
                "<leader>ss",
                function()
                    require("persistence").select()
                end,
                desc = "Select Session",
            },
            {
                "<leader>sa",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "Restore Last Session",
            },
            {
                "<leader>sx",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't Save Current Session",
            },
        },
    },

    -- https://github.com/leath-dub/snipe.nvim
    -- Snipe.nvim: Efficient targetted menu built for fast buffer navigation
    {
        "leath-dub/snipe.nvim",
        keys = {
            {
                "<Leader>z",
                function()
                    require("snipe").open_buffer_menu()
                end,
                desc = "Open Snipe buffer menu",
            },
        },
        opts = {
            ui = {
                position = "topright",
                open_win_override = {
                    border = "rounded",
                },
                -- Preselect the currently open buffer
                ---@type boolean
                preselect_current = true,
            },
            hints = {
                -- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
                ---@type string
                dictionary = "sadflewcmpghio",
                -- Character used to disambiguate tags when 'persist_tags' option is set
                prefix_key = ".",
            },
            navigate = {
                -- When the list is too long it is split into pages
                -- `[next|prev]_page` options allow you to navigate
                -- this list
                next_page = "J",
                prev_page = "K",
            },
        },
    },

    -- https://github.com/mrjones2014/codesettings.nvim
    -- codesettings.nvim: Easily read your project's local settings files and merge them into your
    -- Neovim 0.11+ native LSP configuration.
    {
        "mrjones2014/codesettings.nvim",
        config = function()
            require("codesettings").setup({
                ---Look for these config files
                config_file_paths = { ".vscode/settings.json", "codesettings.json", "lspsettings.json" },
                ---List of loader extensions to use when loading settings; `string` values will be `require`d
                loader_extensions = { "codesettings.extensions.vscode" },
            })
            --[[
            -- This requires to overwrite the `before_init` function for all LSPs.
            -- We actually need `before_init` in `nvim-lspconfig`, so we can't just set it here.
            vim.lsp.config('*', {
                before_init = function(_, config)
                    local codesettings = require('codesettings')
                    codesettings.with_local_settings(config.name, config)
                end,
            })
            --]]
            local codesettings = require("codesettings")
            local lsp_config = require("config.lsp")
            for _, lsp_name in ipairs(lsp_config.lsp_list) do
                if lsp_name ~= "rust-analyzer" then
                    -- rust-analyzer is enabled by rustaceanvim, so we skip it here to avoid conflicts
                    local local_config = lsp_config.get_local_settings(lsp_name)
                    local success, final_config = pcall(codesettings.with_local_settings, lsp_name, local_config)
                    if success then
                        vim.lsp.config(lsp_name, final_config)
                    end
                end
            end
        end,
        -- I recommend loading on these filetype so that the
        -- jsonls integration, lua_ls integration, and jsonc filetype setup works
        ft = { "json", "jsonc", "lua" },
    },
}
