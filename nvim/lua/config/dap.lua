-- reference: https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

-- C/C++/rust: /home/c163q/.local/share/nvim/mason/packages/cpptools

-- https://github.com/patricorgi/dotfiles/blob/main/.config/nvim/lua/custom/config/dapui.lua

local dap = require('dap')
local homePath = require('core.config').homePath
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = vim.fs.joinpath(homePath, '.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7'),
}

dap.adapters.codelldb = {
    type = "executable",
    command = vim.fs.joinpath(homePath, ".local/share/nvim/mason/packages/codelldb/codelldb"),
}

-- set Breakpoint Color
vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = "#ff0505" })
vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#ff8205' })
vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#42cf00' })
vim.api.nvim_set_hl(0, 'DapBreakpointLine', { bg = "#6b0000" })
vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { bg = '#6b4d00' })
vim.api.nvim_set_hl(0, 'DapStopped', { bg = '#004d08' })

-- Custom breakpoint icons
vim.fn.sign_define(
    'DapBreakpoint',
    { text = '', texthl = 'DapBreakpoint',
    linehl = 'DapBreakpointLine', numhl = 'DapBreakpoint' }
)
vim.fn.sign_define(
    'DapBreakpointCondition',
    { text = '', texthl = 'DapBreakpointCondition',
    linehl = 'DapBreakpointConditionLine', numhl = 'DapBreakpointCondition' }
)
vim.fn.sign_define(
    'DapStopped',
    { text = '', texthl = 'DapStopped',
    linehl = 'DapStoppedLine', numhl = 'DapStopped' }
)

local keymap = vim.keymap

keymap.set('n', '<leader>ds', dap.continue, { desc = ' Start/Continue' })
keymap.set('n', '<F5>', dap.continue, { desc = ' Start/Continue' })
keymap.set('n', '<leader>di', dap.step_into, { desc = ' Step into' })
keymap.set('n', '<F9>', dap.step_into, { desc = ' Step into' })
keymap.set('n', '<leader>do', dap.step_over, { desc = ' Step over' })
keymap.set('n', '<F10>', dap.step_over, { desc = ' Step over' })
keymap.set('n', '<leader>dO', dap.step_out, { desc = ' Step out' })
keymap.set('n', '<F6>', dap.step_out, { desc = ' Step out' })
keymap.set('n', '<leader>dQ', dap.terminate, { desc = ' Terminate session' })
keymap.set('n', '<S-F12>', dap.terminate, { desc = ' Terminate session' })
keymap.set('n', '<leader>dR', dap.restart_frame, { desc = 'DAP: Restart' })
keymap.set('n', '<S-F5>', dap.restart_frame, { desc = 'DAP: Restart' })

keymap.set('n', '<leader>dc', dap.run_to_cursor, { desc = 'DAP: Run to Cursor' })
keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = 'DAP: Toggle REPL' })

-- Show variables info when press <Leader>dh
vim.keymap.set('n', '<leader>dh',
    function()
        require('dap.ui.widgets').hover()
    end,
    { desc = 'DAP: Hover' })
vim.keymap.set('n', '<leader>.',
    function()
        require('dap.ui.widgets').hover()
    end,
    { desc = 'DAP: Hover' })

keymap.set('n', '<F8>', dap.toggle_breakpoint, { desc = 'DAP: Breakpoint' })
keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Breakpoint' })
keymap.set(
    'n', '<leader>dB',
    function()
        local input = vim.fn.input('Condition for breakpoint:')
        dap.set_breakpoint(input)
    end,
    { desc = 'DAP: Conditional Breakpoint' }
)
keymap.set('n', '<leader>dD', dap.clear_breakpoints, { desc = 'DAP: Clear Breakpoints' })

