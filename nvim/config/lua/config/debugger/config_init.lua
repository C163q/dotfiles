local task_list = { "cppTask", "pythonTask", "rustTask" }

for _, task in ipairs(task_list) do
    local status_ok, _ = pcall(require, "config.debugger." .. task)
    if not status_ok then
        vim.notify("Failed to load debugger configuration for " .. task, vim.log.levels.ERROR)
    end
end
