return {
    -- https://github.com/nvim-mini/mini.nvim
    -- Library of 40+ independent Lua modules improving overall Neovim (version 0.9 and higher) experience with minimal effort.
    -- They all share same configuration approaches and general design principles.
    {
        "nvim-mini/mini.nvim",
        event = "VeryLazy",
        version = "*",
        config = function()
            require("mini.ai").setup({})
            require("mini.diff").setup({
                view = {
                    style = 'number',
                    priority = 1, -- We already have `gitsigns.nvim` for that.
                },
                -- Module mappings. Use `''` (empty string) to disable one.
                --[[
                mappings = {
                    -- Apply hunks inside a visual/operator region
                    apply = 'gh',

                    -- Reset hunks inside a visual/operator region
                    reset = 'gH',

                    -- Hunk range textobject to be used inside operator
                    -- Works also in Visual mode if mapping differs from apply and reset
                    textobject = 'gh',

                    -- Go to hunk range in corresponding direction
                    goto_first = '[H',
                    goto_prev = '[h',
                    goto_next = ']h',
                    goto_last = ']H',
                },
                --]]
            })

            vim.keymap.set("n", "<Leader>fd", function()
                require("mini.diff").toggle_overlay(0)
            end, { noremap = true, desc = "Toggle diff overlay" })
        end,
    },
}
