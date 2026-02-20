-- SEE: https://neovim.io/doc/user/lsp.html#lsp-config
-- https://github.com/neovim/nvim-lspconfig?tab=readme-ov-file#vimlspconfig
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

-- The first link tells you how `vim.lsp.config()` and `lsp/` merged.

local M = {}

M.lsp_list = { "lua_ls", "clangd", "basedpyright", "asm_lsp", "neocmake", "rust-analyzer" }

M.setup = function()
    -- This initialize the LSP function selection menu
    require("config.lsp.core")

    for _, lsp_name in ipairs(M.lsp_list) do
        local success, lsp = pcall(require, "config.lsp." .. lsp_name)
        if success then
            pcall(lsp.setup)
        end
    end

    -- general diagnostic configuration
    require("config.lsp.diagnostic")

    -- enable configuration for all LSPs in the list, even those without specific configuration
    for _, lsp_name in ipairs(M.lsp_list) do
        if lsp_name ~= "rust-analyzer" then
            -- rust-analyzer is enabled by rustaceanvim, so we skip it here to avoid conflicts
            pcall(vim.lsp.enable, lsp_name)
        end
    end
end

--- For `codesettings` plugin: get local settings for the given LSP name,
--- if any local config files were found, empty table otherwise.
---@param lsp_name string
---@return table
M.get_local_settings = function(lsp_name)
    local success, lsp = pcall(require, "config.lsp" .. lsp_name)
    if success and lsp.get_local_settings ~= nil then
        return lsp.get_local_settings()
    else
        return vim.lsp.config[lsp_name] or {}
    end
end

return M
