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
                Up = '↑',
                Down = '↓',
                Left = '←',
                Right = '→',
                C = '󰘴',
                M = '󰘳',
                S = '󰘶',
                CR = '󰌑',
                Esc = '󱊷',
                ScrollWheelDown = '󱕐',
                ScrollWheelUp = '󱕑',
                NL = '󰼧',
                BS = '󰌍',
                Space = '󱁐',
                Tab = '󰌒',
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
