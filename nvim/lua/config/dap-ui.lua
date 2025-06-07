
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

require("dapui").setup {
    layouts = {
    {
        elements = {
        {
            id = "scopes",
            size = 0.4
        },
        {
            id = "breakpoints",
            size = 0.15
        },
        {
            id = "stacks",
            size = 0.15
        },
        {
            id = "watches",
            size = 0.3
        }
        },
    position = "left",
    size = 0.25
    },
    {
        elements = {
        {
            id = "repl",
            size = 0.5
        },
        {
            id = "console",
            size = 0.5
        }
        },
    position = "bottom",
    size = 0.2
    }
    },
}

local keymap = vim.keymap

keymap.set(
    'n',
    '<Leader>du',
    dapui.toggle,
    {
        noremap = true,
        desc = "Toggle debugger UI"
    }
)

keymap.set(
    'n',
    '<Leader>dv',
    function()
        local input = vim.fn.input('Name of Element:')
        dapui.float_element(input, {
            width = 30,
            height = 10,
            enter = false,
            position = nil,
        })
    end,
    {
        noremap = true,
        desc = "Show float window of element",
    }
)

