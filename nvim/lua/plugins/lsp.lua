return {
    -- https://github.com/mason-org/mason.nvim
    -- mason.nvim: Portable package manager for Neovim that runs everywhere Neovim runs.
    --   Easily install and manage LSP servers, DAP servers, linters, and formatters.
    {
        "mason-org/mason.nvim",
        event = 'VeryLazy',
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
        version = "*",
    },

    -- https://github.com/mason-org/mason-lspconfig.nvim
    -- mason-lspconfig bridges mason.nvim with the lspconfig plugin - making it easier to use both plugins together.
    {
        "mason-org/mason-lspconfig.nvim",
        event = 'VeryLazy',
        opts = {
            ensure_installed = {
                'basedpyright',
                'bashls',
                'clangd',
                'jdtls',
                'jsonls',
                'lua_ls',
                'vtsls',
            },
        },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        version = "*",
    },

    -- https://github.com/folke/trouble.nvim
    -- Trouble: A pretty list for showing diagnostics, references, telescope results,
    -- quickfix and location lists to help you solve all the trouble your code is causing.
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>lx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>lX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>ls",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>ll",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>lL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>lQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },

}
