return {
    -- https://github.com/mason-org/mason.nvim
    -- mason.nvim: Portable package manager for Neovim that runs everywhere Neovim runs.
    --   Easily install and manage LSP servers, DAP servers, linters, and formatters.
    {
        "mason-org/mason.nvim",
        dependencies = {
            -- Install or upgrade all of your third-party tools.
            -- Link: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
            'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    },

    -- https://github.com/neovim/nvim-lspconfig
    -- nvim-lspconfig is a "data only" repo, providing basic, default Nvim LSP client configurations for various LSP servers.
    {
        "neovim/nvim-lspconfig",
    },

    -- https://github.com/mason-org/mason-lspconfig.nvim
    -- mason-lspconfig bridges mason.nvim with the lspconfig plugin - making it easier to use both plugins together.
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },

}
