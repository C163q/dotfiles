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
}
