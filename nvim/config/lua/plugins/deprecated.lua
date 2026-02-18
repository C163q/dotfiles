return {
    --[[
    -- https://github.com/olimorris/onedarkpro.nvim
    -- onedarkpro colorscheme
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme onedark")
        end
    },
    --]]

    --[[
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    -- Indent Blankline: This plugin adds indentation guides to Neovim.
    -- It uses Neovim's virtual text feature and no conceal
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { 'BufReadPost', 'BufNewFile' },
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        config = function()
            local hooks = require "ibl.hooks"
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, 'CurrentScope', { fg = "#8a8466" })
            end)
            require("ibl").setup({
                scope = { highlight = 'CurrentScope' }
            })
        end,
    },
    --]]

    --[[
    -- https://github.com/cappyzawa/trim.nvim
    -- trim.nvim: This plugin trims trailing whitespace and lines.
    {
        "cappyzawa/trim.nvim",
        event = event_presets.start_edit,
        config = function()
            -- We just use this plugin to highlight the trailing whitespaces.
            local config = {
                trim_on_write = false,
                trim_trailing = false,
                trim_last_line = false,
                trim_first_line = false,
                trim_current_line = false,
                highlight = true,
                highlight_bg = '#c00000',
                highlight_ctermbg = 'red',
                notifications = true,
            }
            require("trim").setup(config)
            -- :TrimToggle
            -- Toggle trim on save.
            -- :Trim
            -- Trim the buffer right away. Supports range selection (e.g., :'<,'>Trim to trim only selected lines).
        end,
    },
    --]]

    --[[
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
    --]]

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
}
