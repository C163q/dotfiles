local keys_icon = require('core.config').icon.keys

return {
    -- https://github.com/folke/which-key.nvim
    -- WhichKey helps you remember your Neovim keymaps, by showing available keybindings in a popup as you type.
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = 'modern',
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
    }

}
