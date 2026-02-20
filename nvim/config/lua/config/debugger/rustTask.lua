local dap = require("dap")
dap.configurations.rust = dap.configurations.rust or {}
local rust_cfg = dap.configurations.rust

rust_cfg[#rust_cfg + 1] = {
    name = "Launch file (codelldb)",
    type = "codelldb",
    request = "launch",
    -- reference: https://github.com/cap153/nvim/blob/main/lua/lazy/plugins/dap.lua
    program = function()
        -- 0. run 'cargo build' to compile executable
        vim.fn.system("cargo build")
        -- 1. run 'cargo metadata' to obtain JSON with executable name
        local cargo_metadata_json = vim.fn.system("cargo metadata --no-deps --format-version 1")
        if vim.v.shell_error ~= 0 then
            vim.notify("Error running 'cargo metadata': " .. cargo_metadata_json, vim.log.levels.ERROR)
            return nil
        end
        -- 2. parse JSON
        local cargo_metadata = vim.fn.json_decode(cargo_metadata_json)
        -- 3. obtain workspace dir name from metadata
        local project_root = cargo_metadata.workspace_root
        -- 4. find name of binary
        local executable_name = nil
        -- focus on workspace members only
        for _, member_id in ipairs(cargo_metadata.workspace_members) do
            for _, package in ipairs(cargo_metadata.packages) do
                if package.id == member_id then
                    for _, target in ipairs(package.targets) do
                        -- find first object whose kind is "bin"
                        if target.kind[1] == "bin" then
                            executable_name = target.name
                            break
                        end
                    end
                end
                if executable_name then
                    break
                end
            end
            if executable_name then
                break
            end
        end
        if not executable_name then
            vim.notify("Unable to find executable. Input manually!", vim.log.levels.ERROR)
            return vim.fn.input("Path to executable: ", vim.fs.joinpath(project_root, "/target/debug/"), "file")
        end
        -- 5. return the final path
        local exec_path = vim.fs.joinpath(project_root, "target", "debug", executable_name)
        vim.notify("DAP launching: " .. exec_path, vim.log.levels.INFO)
        return exec_path
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
}
