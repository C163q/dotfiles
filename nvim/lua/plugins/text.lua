-- Highlight color
return {

    -- https://github.com/numToStr/Comment.nvim
    -- // Comment.nvim: Smart and Powerful commenting plugin for neovim
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        }
    },

    -- https://github.com/windwp/nvim-autopairs
    -- nvim-autopairs: A super powerful autopair plugin for Neovim that supports multiple characters.
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },

    -- https://github.com/nvim-tree/nvim-web-devicons
    -- Nvim-web-devicons: Provides Nerd Font icons (glyphs) for use by Neovim plugins
    {
        "nvim-tree/nvim-web-devicons", opts = {}
    },

    -- https://github.com/echasnovski/mini.nvim
    -- Library of 40+ independent Lua modules improving overall Neovim (version 0.9 and higher) experience with minimal effort.
    -- They all share same configuration approaches and general design principles.
    {
        'echasnovski/mini.nvim', version = '*'
    },

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

    -- https://github.com/catgoose/nvim-colorizer.lua
    -- NvChad/nvim-colorizer.lua has moved, supports custom colors. Now being maintained
    -- https://www.reddit.com/r/neovim/comments/1hjjhvb/nvchadnvimcolorizerlua_has_moved_supports_custom/
    -- colorizer.lua: A high-performance color highlighter for Neovim which has no external dependencies! Written in performant Luajit.
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = { -- set to setup table
        },
    }
}
