local M = {}

M.task_list = { "cppTask", "pythonTask", "rustTask" }

function M.setup()
    for _, task in ipairs(M.task_list) do
        local status_ok, _ = pcall(require, "config.debugger." .. task)
        if not status_ok then
            vim.notify("Failed to load debugger configuration for " .. task, vim.log.levels.ERROR)
        end
    end
end

return M
