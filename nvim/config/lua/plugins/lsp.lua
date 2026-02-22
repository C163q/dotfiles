local event_presets = require("core.config").event_presets

return {
    -- https://github.com/mason-org/mason.nvim
    -- mason.nvim: Portable package manager for Neovim that runs everywhere Neovim runs.
    --   Easily install and manage LSP servers, DAP servers, linters, and formatters.
    {
        "mason-org/mason.nvim",
        event = "VeryLazy",
        dependencies = {
            -- Install or upgrade all of your third-party tools.
            -- Link: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
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
        event = "VeryLazy",
        opts = {
            ensure_installed = require("core.config").mason_install,
        },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        version = "*",
    },

    -- https://github.com/mrcjkb/rustaceanvim
    -- rustaceanvim: Supercharge your Rust experience in Neovim! A heavily modified fork of rust-tools.nvim
    {
        -- This plugin automatically configures the rust-analyzer builtin LSP client and integrates with other Rust tools.
        "mrcjkb/rustaceanvim",
        version = "^8", -- Recommended
        lazy = false, -- This plugin is already lazy
    },

    -- https://github.com/mfussenegger/nvim-lint
    -- nvim-lint: An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to
    -- the built-in Language Server Protocol support.
    --
    -- nvim-lint complements the built-in language server client for languages where there are
    -- no language servers, or where standalone linters provide better results.
    {
        "mfussenegger/nvim-lint",
        event = event_presets.start_edit,
        config = function()
            -- See https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
            -- for available linters
            require('lint').linters_by_ft = {
                markdown = { 'markdownlint-cli2' },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    -- try_lint without arguments runs the linters defined in `linters_by_ft`
                    -- for the current filetype
                    require("lint").try_lint()
                end,
            })
        end
    },
}
