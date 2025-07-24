local event_presets = require('core.config').event_presets

require("lazydev").setup({
    library = { "nvim-dap-ui" },
})

return {

    -- https://github.com/mfussenegger/nvim-dap
    -- DAP (Debug Adapter Protocol): nvim-dap is a Debug Adapter Protocol client implementation for Neovim.
    {
        'mfussenegger/nvim-dap',
        event = "VeryLazy",
        config = function()
            require('config.dap')
            require("config.debugger.config_init")
        end,
    },

    -- https://github.com/rcarriga/nvim-dap-ui
    -- nvim-dap-ui: A UI for nvim-dap which provides a good out of the box configuration.
    {
        "rcarriga/nvim-dap-ui",
        event = event_presets.start_edit,
        dependencies = { "mfussenegger/nvim-dap",
                         {
                            -- https://github.com/theHamsta/nvim-dap-virtual-text
                            -- nvim-dap-virtual-text: This plugin adds virtual text support to nvim-dap.
                            -- nvim-treesitter is used to find variable definitions.
                            "nvim-dap-virtual-text",
                            dependencies = { 'mfussenegger/nvim-dap', 'nvim-treesitter/nvim-treesitter' },
                         },
                         "nvim-neotest/nvim-nio",
                         "folke/noice.nvim" },
        config = function()
            require('nvim-dap-virtual-text').setup({}) -- optional
            require('config.dap-ui')
        end,

    },

    -- https://github.com/mfussenegger/nvim-dap-python
    -- nvim-dap-python: An extension for nvim-dap providing default configurations for python
    -- and methods to debug individual test methods or classes.
    {
        'mfussenegger/nvim-dap-python',
        dependencies = { 'mfussenegger/nvim-dap', "rcarriga/nvim-dap-ui" },
        ft = { 'python' },
        config = function ()
            local path = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
            require('dap-python').setup(path)
        end,
    },

    -- https://github.com/mrcjkb/rustaceanvim
    -- rustaceanvim: Supercharge your Rust experience in Neovim! A heavily modified fork of rust-tools.nvim
    {
        -- This plugin automatically configures the rust-analyzer builtin LSP client and integrates with other Rust tools.
        'mrcjkb/rustaceanvim',
        version = '^6', -- Recommended
        lazy = false, -- This plugin is already lazy
    }
}
