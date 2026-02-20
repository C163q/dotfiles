local M = {}
local lsp_core = require('config.lsp.core')
M.lsp_name = nil

M.setup = function()
    -- Because of rustaceanvim, we can't use vim.lsp.config directly.
    -- see https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#gear-advanced-configuration
    vim.g.rustaceanvim = {
        server = {
            on_init = function(client, _)
                M.lsp_name = client.name or "rust-analyzer"
                -- rust-analyzer: change features dynamically
                lsp_core.add_lsp_selection(M.lsp_name, 'ChFeat', 'set features', function()
                    local new_features = {}
                    local input = vim.fn.input("Set features (separated by spaces, empty to clear): ")
                    for s in string.gmatch(input, "%S+") do
                        new_features[#new_features + 1] = s
                    end

                    vim.notify("Setting rust-analyzer features to: " .. vim.inspect(new_features), 1)

                    local config_copy = client.config
                    config_copy.settings["rust-analyzer"] = config_copy.settings["rust-analyzer"] or {}
                    config_copy.settings["rust-analyzer"].cargo = config_copy.settings["rust-analyzer"].cargo or {}
                    config_copy.settings["rust-analyzer"].cargo.features = new_features
                    vim.lsp.config('rust-analyzer', config_copy)

                    -- Restart rust-analyzer
                    --
                    -- Never use `client:stop()` and `vim.lsp.start()` to restart the client,
                    -- use command `LspRestart rust-analyzer` instead.
                    --
                    -- If the plugin `rustaceanvim` is applied, you should use `RustAnalyzer restart`
                    -- command to restart rust-analyzer.
                    vim.cmd('RustAnalyzer restart')
                    -- lsp_core.client_stop_helper(client, true)
                    -- local new_client_id = vim.lsp.start(config_copy)
                    -- if new_client_id ~= nil then
                    --     vim.lsp.buf_attach_client(event.buf, new_client_id)
                    -- end
                end)
            end
        },
    }
end

return M
