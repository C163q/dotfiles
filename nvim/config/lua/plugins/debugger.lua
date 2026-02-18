local event_presets = require("core.config").event_presets

return {

    -- https://github.com/mfussenegger/nvim-dap
    -- DAP (Debug Adapter Protocol): nvim-dap is a Debug Adapter Protocol client implementation for Neovim.
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        config = function()
            require("config.dap")
            require("config.debugger.config_init")
        end,
    },

    -- https://github.com/rcarriga/nvim-dap-ui
    -- nvim-dap-ui: A UI for nvim-dap which provides a good out of the box configuration.
    {
        "rcarriga/nvim-dap-ui",
        event = event_presets.start_edit,
        dependencies = {
            "mfussenegger/nvim-dap",
            {
                -- https://github.com/theHamsta/nvim-dap-virtual-text
                -- nvim-dap-virtual-text: This plugin adds virtual text support to nvim-dap.
                -- nvim-treesitter is used to find variable definitions.
                "theHamsta/nvim-dap-virtual-text",
                dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
            },
            "nvim-neotest/nvim-nio",
            "folke/noice.nvim",
        },
        config = function()
            require("lazydev").setup({
                library = { "nvim-dap-ui" },
            })

            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            require("dapui").setup({
                layouts = {
                    {
                        elements = {
                            {
                                id = "scopes",
                                size = 0.4,
                            },
                            {
                                id = "breakpoints",
                                size = 0.15,
                            },
                            {
                                id = "stacks",
                                size = 0.15,
                            },
                            {
                                id = "watches",
                                size = 0.3,
                            },
                        },
                        position = "left",
                        size = 0.25,
                    },
                    {
                        elements = {
                            {
                                id = "repl",
                                size = 0.5,
                            },
                            {
                                id = "console",
                                size = 0.5,
                            },
                        },
                        position = "bottom",
                        size = 0.2,
                    },
                },
            })

            -- Don't move these keymaps to `keys` since dapui isn't loaded before editing
            vim.keymap.set("n", "<Leader>du", dapui.toggle, { noremap = true, desc = "Toggle debugger UI" })
            vim.keymap.set("n", "<Leader>dv", function()
                local input = vim.fn.input("Name of Element:")
                require("dapui").float_element(input, {
                    width = 30,
                    height = 10,
                    enter = false,
                    position = nil,
                })
            end, { noremap = true, desc = "Show float window of element" })
        end,
        keys = {
            -- Placeholder ketmaps. Which-key will show them before dapui is loaded
            { "<Leader>du", nil, noremap = true, desc = "Toggle debugger UI" },
            { "<Leader>dv", nil, noremap = true, desc = "Show float window of element" },
        }
    },

    -- https://github.com/mfussenegger/nvim-dap-python
    -- nvim-dap-python: An extension for nvim-dap providing default configurations for python
    -- and methods to debug individual test methods or classes.
    {
        "mfussenegger/nvim-dap-python",
        dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
        ft = { "python" },
        config = function()
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
        end,
    },

    -- https://github.com/theHamsta/nvim-dap-virtual-text
    -- nvim-dap-virtual-text: This plugin adds virtual text support to nvim-dap.
    -- nvim-treesitter is used to find variable definitions.
    {
        "theHamsta/nvim-dap-virtual-text",
        event = event_presets.start_edit,
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        opt = {},
    },
}
