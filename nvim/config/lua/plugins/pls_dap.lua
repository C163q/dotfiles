local event_presets = require("core.config").event_presets

return {

    -- https://github.com/mfussenegger/nvim-dap
    -- DAP (Debug Adapter Protocol): nvim-dap is a Debug Adapter Protocol client implementation for Neovim.
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        config = function()
            -- Guide: https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
            -- **Reference**: https://github.com/patricorgi/dotfiles/blob/main/.config/nvim/lua/custom/config/dapui.lua
            -- C/C++/rust: ~/.local/share/nvim/mason/packages/cpptools

            local dap = require("dap")
            local home_path = require("core.config").home_path
            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = vim.fs.joinpath(
                    home_path,
                    ".local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
                ),
            }

            dap.adapters.codelldb = {
                type = "executable",
                command = vim.fs.joinpath(home_path, ".local/share/nvim/mason/packages/codelldb/codelldb"),
            }

            -- set breakpoint color
            vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff0505" })
            vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#ff8205" })
            vim.api.nvim_set_hl(0, "DapStopped", { fg = "#42cf00" })
            vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#6b0000" })
            vim.api.nvim_set_hl(0, "DapBreakpointCondition", { bg = "#6b4d00" })
            vim.api.nvim_set_hl(0, "DapStopped", { bg = "#004d08" })

            -- custom breakpoint icons
            vim.fn.sign_define(
                "DapBreakpoint",
                { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint" }
            )
            vim.fn.sign_define("DapBreakpointCondition", {
                text = "",
                texthl = "DapBreakpointCondition",
                linehl = "DapBreakpointConditionLine",
                numhl = "DapBreakpointCondition",
            })
            vim.fn.sign_define(
                "DapStopped",
                { text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStopped" }
            )

            local keymap = vim.keymap

            keymap.set("n", "<leader>ds", dap.continue, { desc = " Start/Continue" })
            keymap.set("n", "<F5>", dap.continue, { desc = " Start/Continue" })
            keymap.set("n", "<leader>di", dap.step_into, { desc = " Step into" })
            keymap.set("n", "<F9>", dap.step_into, { desc = " Step into" })
            keymap.set("n", "<leader>do", dap.step_over, { desc = " Step over" })
            keymap.set("n", "<F10>", dap.step_over, { desc = " Step over" })
            keymap.set("n", "<leader>dO", dap.step_out, { desc = " Step out" })
            keymap.set("n", "<F6>", dap.step_out, { desc = " Step out" })
            keymap.set("n", "<leader>dQ", dap.terminate, { desc = " Terminate session" })
            keymap.set("n", "<S-F12>", dap.terminate, { desc = " Terminate session" })
            keymap.set("n", "<leader>dR", dap.restart_frame, { desc = "DAP: Restart" })
            keymap.set("n", "<S-F5>", dap.restart_frame, { desc = "DAP: Restart" })

            keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })
            keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "DAP: Toggle REPL" })

            -- Show variables info when press <Leader>dh
            vim.keymap.set("n", "<leader>dh", function()
                require("dap.ui.widgets").hover()
            end, { desc = "DAP: Hover" })
            vim.keymap.set("n", "<leader>.", function()
                require("dap.ui.widgets").hover()
            end, { desc = "DAP: Hover" })

            keymap.set("n", "<F8>", dap.toggle_breakpoint, { desc = "DAP: Breakpoint" })
            keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Breakpoint" })
            keymap.set("n", "<leader>dB", function()
                local input = vim.fn.input("Condition for breakpoint:")
                dap.set_breakpoint(input)
            end, { desc = "DAP: Conditional Breakpoint" })
            keymap.set("n", "<leader>dD", dap.clear_breakpoints, { desc = "DAP: Clear Breakpoints" })
            require("config.debugger").setup()
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
        },
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
