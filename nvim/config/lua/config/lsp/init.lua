-- SEE: https://neovim.io/doc/user/lsp.html#lsp-config
-- https://github.com/neovim/nvim-lspconfig?tab=readme-ov-file#vimlspconfig
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

-- The first link tells you how `vim.lsp.config()` and `lsp/` merged.
local config = require("core.config")
require('config.lsp.core').setup()

vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
-- vim.lsp.enable('pyright')
vim.lsp.enable("basedpyright")
vim.lsp.enable("asm_lsp")
vim.lsp.enable("neocmake")

require("config.lsp.lua_ls").setup()
require("config.lsp.rust_analyzer").setup()

local basedpyright_settings = require("config.lsp.basedpyright")
basedpyright_settings.basedpyright_disable_annotation_missing_check(
    config.basedpyright_disable_annotation_missing_check
)
basedpyright_settings.basedpyright_unused_warning(config.basedpyright_unused_warning)
basedpyright_settings.basedpyright_deprecated_warning(config.basedpyright_deprecated_warning)
basedpyright_settings.basedpyright_allow_unused_return(config.basedpyright_allow_unused_return)

require("config.lsp.diagnostic")
