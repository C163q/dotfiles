-- SEE: https://neovim.io/doc/user/lsp.html#lsp-config
-- https://github.com/neovim/nvim-lspconfig?tab=readme-ov-file#vimlspconfig
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

-- The first link tells you how `vim.lsp.config()` and `lsp/` merged.

local M = {}

M.setup = function()
    if M._done then
        return
    end
    M._done = true

    local lsp_list = require("core.config").lsp_list
    local skip_enable = require("core.config").lsp_skip_enable or {}

    -- give the default settings for all LSPs, so that they can be enabled by
    -- `vim.lsp.enable()` without specific configuration
    vim.lsp.config("*", {
        root_markers = { ".git" },
    })

    -- This initialize the LSP function selection menu
    local core = require("config.lsp.core")

    for _, lsp_name in ipairs(lsp_list) do
        local success, lsp = pcall(require, "config.lsp." .. lsp_name)
        if success then
            pcall(lsp.setup)
        end
    end

    -- general diagnostic configuration
    require("config.lsp.basic")
    core.init_lsp_configure()

    -- enable configuration for all LSPs in the list, even those without specific configuration
    for _, lsp_name in ipairs(lsp_list) do
        if not vim.tbl_contains(skip_enable, lsp_name) then
            pcall(vim.lsp.enable, lsp_name)
        end
    end
end

return M
