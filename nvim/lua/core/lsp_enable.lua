-- SEE: https://neovim.io/doc/user/lsp.html#lsp-config
-- https://github.com/neovim/nvim-lspconfig?tab=readme-ov-file#vimlspconfig
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

-- The first link tells you how `vim.lsp.config()` and `lsp/` merged.

_G.MyCustomSettings = {
    basedpyrightTypeCheck = true,
}

vim.lsp.enable('lua_ls')
require('config.lsp.lua_ls')
vim.lsp.enable('clangd')
-- vim.lsp.enable('pyright')
-- vim.lsp.enable('pylsp')
vim.lsp.enable('basedpyright')
require('config.lsp.basedpyright')

require("config.lsp.diagnostic")




