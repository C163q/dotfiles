return {

    -- https://github.com/mfussenegger/nvim-dap
    -- DAP (Debug Adapter Protocol): nvim-dap is a Debug Adapter Protocol client implementation for Neovim.
    {
        'mfussenegger/nvim-dap',
        lazy = true,
        config = function()
            require('config.dap')
        end,
    },

    -- https://github.com/theHamsta/nvim-dap-virtual-text
    -- nvim-dap-virtual-text: This plugin adds virtual text support to nvim-dap.
    -- nvim-treesitter is used to find variable definitions.
    {
        'theHamsta/nvim-dap-virtual-text',
        dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
        opts = {},
    },

    -- https://github.com/rcarriga/nvim-dap-ui
    -- nvim-dap-ui: A UI for nvim-dap which provides a good out of the box configuration.
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-dap-virtual-text", "nvim-neotest/nvim-nio", "folke/noice.nvim" },
        -- lazy=true,
        config = function()
            require('nvim-dap-virtual-text').setup() -- optional
            require('config.dap-ui')
        end,

    },
--]]
}
