local keys_icon = require("core.config").icon.keys
local event_presets = require("core.config").event_presets

return {
    -- https://github.com/folke/which-key.nvim
    -- WhichKey helps you remember your Neovim keymaps, by showing available keybindings in a popup as you type.
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "modern",
            icons = {
                colors = true,
                keys = {
                    Up = keys_icon.Up,
                    Down = keys_icon.Down,
                    Left = keys_icon.Left,
                    Right = keys_icon.Right,
                    C = keys_icon.C,
                    M = keys_icon.M,
                    S = keys_icon.S,
                    CR = keys_icon.CR,
                    Esc = keys_icon.Esc,
                    ScrollWheelDown = keys_icon.ScrollWheelDown,
                    ScrollWheelUp = keys_icon.ScrollWheelUp,
                    NL = keys_icon.NL,
                    BS = keys_icon.BS,
                    Space = keys_icon.Space,
                    Tab = keys_icon.Tab,
                },
            },
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    -- https://github.com/JuanZoran/Trans.nvim
    -- Trans.nvim: 离线和在线翻译的支持
    {
        "JuanZoran/Trans.nvim",
        build = function()
            require("Trans").install()
        end,
        keys = {
            { "mm", mode = { "n", "x" }, "<Cmd>TransWord<CR>", desc = "󰊿 Translate" },
            { "mk", mode = { "n", "x" }, "<Cmd>TransPlay<CR>", desc = " Auto Play" },
            { "mi", "<Cmd>TranslateInput<CR>", desc = "󰊿 Translate From Input" },
        },
        dependencies = { "kkharji/sqlite.lua", event = "VeryLazy" },
        config = function()
            require("Trans").setup({
                dir = os.getenv("HOME") .. "/Documents/dict",
                frontend = {
                    hover = {
                        keymaps = {
                            pageup = "<C-g>",
                            pagedown = "<C-f>",
                            pin = "mp",
                            close = "mc",
                            toggle_entry = "m;",
                        },
                    },
                },
            })

            -- uga-rosa/translate.nvim and JuanZoran/Trans.nvim both use :Translate command
            -- to translate, so we need to set a different command to avoid conflict
            local Trans = require("Trans")
            vim.api.nvim_create_user_command("TransWord", function()
                Trans.translate()
            end, { desc = "󰊿 Translate cursor word" })
        end,
        event = event_presets.start_edit,
    },

    -- https://github.com/uga-rosa/translate.nvim
    -- translate.nvim
    {
        "uga-rosa/translate.nvim",
        event = event_presets.start_edit,
        config = function()
            vim.api.nvim_set_keymap(
                "n",
                "mr",
                "viw:Translate ZH -output=replace<CR>",
                { noremap = true, silent = true, desc = "󰊿 Translate word online Replace" }
            )
            vim.api.nvim_set_keymap(
                "v",
                "mr",
                ":'<,'>Translate ZH -output=replace<CR>",
                { noremap = true, silent = true, desc = "󰊿 Translate word online Replace" }
            )
            vim.api.nvim_set_keymap(
                "n",
                "ml",
                "viw:Translate ZH<CR>",
                { noremap = true, silent = true, desc = "󰊿 Translate word online" }
            )
            vim.api.nvim_set_keymap(
                "v",
                "ml",
                ":'<,'>Translate ZH<CR>",
                { noremap = true, silent = true, desc = "󰊿 Translate word online" }
            )
            require("translate").setup({
                default = {
                    command = "translate_shell",
                },
                preset = {
                    command = {
                        translate_shell = {
                            args = { "-e", "google" },
                        },
                    },
                },
            })
        end,
    },
}
