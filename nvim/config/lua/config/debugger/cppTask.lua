local dap = require('dap')
dap.configurations.cpp = {
    {
        name = "Launch file (cppdbg)",
        type = "cppdbg",
        request = "launch",
        program = function()
            local exec_path = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            vim.notify("DAP launching: " .. exec_path, vim.log.levels.INFO)
            return exec_path
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        setupCommands = {
            {
                text = '-enable-pretty-printing',
                description =  'enable pretty printing',
                ignoreFailures = false
            },
        },
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb",
    },
}

dap.configurations.c = dap.configurations.cpp

