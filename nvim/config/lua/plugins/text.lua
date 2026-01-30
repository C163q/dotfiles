local event_presets = require("core.config").event_presets

-- Highlight color
return {

    -- https://github.com/numToStr/Comment.nvim
    -- // Comment.nvim: Smart and Powerful commenting plugin for neovim
    {
        "numToStr/Comment.nvim",
        event = event_presets.start_edit,
        opts = {
            -- add any options here
        },
    },

    -- https://github.com/windwp/nvim-autopairs
    -- nvim-autopairs: A super powerful autopair plugin for Neovim that supports multiple characters.
    {
        "windwp/nvim-autopairs",
        event = event_presets.start_insert,
        config = function()
            require("config.complement.autopairs")
        end,
    },

    --[[
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    -- Indent Blankline: This plugin adds indentation guides to Neovim.
    -- It uses Neovim's virtual text feature and no conceal
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { 'BufReadPost', 'BufNewFile' },
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        config = function()
            local hooks = require "ibl.hooks"
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, 'CurrentScope', { fg = "#8a8466" })
            end)
            require("ibl").setup({
                scope = { highlight = 'CurrentScope' }
            })
        end,
    },
    --]]

    -- https://github.com/catgoose/nvim-colorizer.lua
    -- NvChad/nvim-colorizer.lua has moved, supports custom colors. Now being maintained
    -- https://www.reddit.com/r/neovim/comments/1hjjhvb/nvchadnvimcolorizerlua_has_moved_supports_custom/
    -- colorizer.lua: A high-performance color highlighter for Neovim which has no external dependencies! Written in performant Luajit.
    {
        "catgoose/nvim-colorizer.lua",
        event = event_presets.start_edit,
        opts = { -- set to setup table
        },
    },

    -- https://github.com/stevearc/conform.nvim
    -- conform.nvim: Lightweight yet powerful formatter plugin for Neovim
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    -- You can customize some of the format options for the filetype (:help conform.format)
                    lua = { "stylua" },
                    -- Conform will run multiple formatters sequentially
                    python = { "isort", "black" },
                    rust = { "rustfmt", lsp_format = "fallback" },
                    cpp = { "clang-format" },
                },
            })
            require("config.conform")
        end,
        event = event_presets.start_edit,
        version = "*",
    },

    -- https://github.com/zapling/mason-conform.nvim
    -- mason-conform.nvim: Automatically install formatters registered with conform.nvim via Mason.
    {
        "zapling/mason-conform.nvim",
        event = event_presets.start_edit,
        dependencies = {
            "mason-org/mason.nvim",
            "stevearc/conform.nvim",
        },
    },

    -- https://github.com/nvim-treesitter/nvim-treesitter/tree/main
    -- The nvim-treesitter plugin provides
    --   functions for installing, updating, and removing tree-sitter parsers;
    --   a collection of queries for enabling tree-sitter features built into Neovim for these languages;
    --   a staging ground for treesitter-based features considered for upstreaming to Neovim.
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.config").setup(opts)
            require("nvim-treesitter").setup()

            local ensure_installed = {
                "rust",
                "javascript",
                "c",
                "lua",
                "cmake",
                "cpp",
                "json",
                "markdown",
                "python",
                "regex",
                "yaml",
                "bash",
                "vim",
            }

            require("nvim-treesitter").install(ensure_installed):wait(30000)

            -- enable highlight
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "<filetype>" },
                callback = function()
                    vim.treesitter.start()
                end,
            })

            -- enable folds
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
    },

    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    -- render-markdown.nvim: Plugin to improve viewing Markdown files in Neovim
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        version = "*",
    },

    -- https://github.com/kevinhwang91/nvim-ufo
    -- nvim-ufo: The goal of nvim-ufo is to make Neovim's fold look modern and keep high performance.
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        -- event = { 'BufReadPost', 'BufNewFile' }, -- Don't Lazy load to enable specific autocommands
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            require("config.ufo")
        end,
    },

    -- https://github.com/folke/flash.nvim
    -- flash.nvim: flash.nvim lets you navigate your code with search labels,
    -- enhanced character motions, and Treesitter integration.
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        config = function()
            require("flash").setup({})
            require("config.flash")
        end,
        keys = {
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },
}
