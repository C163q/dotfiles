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

    -- https://github.com/bullets-vim/bullets.vim
    -- Bullets.vim: Bullets.vim is a Vim plugin for automated bullet lists.
    {
        "bullets-vim/bullets.vim",
        event = event_presets.start_edit,
        config = function()
            -- Note: <CR> for new line with the same bullet, <C-CR> for new line without bullet
            vim.g.bullets_enabled_file_types = {
                "markdown",
                "text",
                "gitcommit",
            }
            vim.g.bullets_delete_last_bullet_if_empty = 2
        end,
    },

    -- https://github.com/MagicDuck/grug-far.nvim
    -- grug-far.nvim: Find And Replace plugin for neovim
    {
        "MagicDuck/grug-far.nvim",
        -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
        -- additional lazy config to defer loading is not really needed...
        config = function()
            -- optional setup call to override plugin options
            -- alternatively you can set options with vim.g.grug_far = { ... }
            vim.keymap.set(
                { "n", "v" },
                "<Leader>sr",
                ":GrugFar<CR>",
                { desc = "Search and Replace", noremap = true }
            )

            vim.keymap.set(
                "v",
                "<Leader>sR",
                ":GrugFarWithin<CR>",
                { desc = "Replace within selection", noremap = true }
            )

            require("grug-far").setup({
                -- options, see Configuration section below
                -- there are no required options atm

                --[[
                -- shortcuts for the actions you see at the top of the buffer
                -- set to '' or false to unset. Mappings with no normal mode value will be removed from the help header
                -- you can specify either a string which is then used as the mapping for both normal and insert mode
                -- or you can specify a table of the form { [mode] = <lhs> } (e.g. { i = '<C-enter>', n = '<localleader>gr'})
                -- it is recommended to use <localleader> though as that is more vim-ish
                -- see https://learnvimscriptthehardway.stevelosh.com/chapters/11.html#local-leader
                keymaps = {
                    replace = { n = '<localleader>r' },
                    qflist = { n = '<localleader>q' },
                    syncLocations = { n = '<localleader>s' },
                    syncLine = { n = '<localleader>l' },
                    close = { n = '<localleader>c' },
                    historyOpen = { n = '<localleader>t' },
                    historyAdd = { n = '<localleader>a' },
                    refresh = { n = '<localleader>f' },
                    openLocation = { n = '<localleader>o' },
                    openNextLocation = { n = '<down>' },
                    openPrevLocation = { n = '<up>' },
                    gotoLocation = { n = '<enter>' },
                    pickHistoryEntry = { n = '<enter>' },
                    abort = { n = '<localleader>b' },
                    help = { n = 'g?' },
                    toggleShowCommand = { n = '<localleader>w' },
                    swapEngine = { n = '<localleader>e' },
                    previewLocation = { n = '<localleader>i' },
                    swapReplacementInterpreter = { n = '<localleader>x' },
                    applyNext = { n = '<localleader>j' },
                    applyPrev = { n = '<localleader>k' },
                    syncNext = { n = '<localleader>n' },
                    syncPrev = { n = '<localleader>p' },
                    syncFile = { n = '<localleader>v' },
                    nextInput = { n = '<tab>' },
                    prevInput = { n = '<s-tab>' },
                },
                --]]
            })
        end,
    },
}
