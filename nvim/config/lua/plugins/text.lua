local event_presets = require("core.config").event_presets

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

    -- https://github.com/kevinhwang91/nvim-ufo
    -- nvim-ufo: The goal of nvim-ufo is to make Neovim's fold look modern and keep high performance.
    {
        "kevinhwang91/nvim-ufo",
        event = "VeryLazy",
        -- event = { 'BufReadPost', 'BufNewFile' }, -- Don't Lazy load to enable specific autocommands
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            -- Tell the server the capability of foldingRange,
            -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
            --[[    Notes: Unnecessary for nvim 0.11+
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
            for _, ls in ipairs(language_servers) do
                require('lspconfig')[ls].setup({
                    capabilities = capabilities
                    -- you can add other fields for setting up lsp server in this table
                })
            end
            --]]

            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (" 󰁂 %d "):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end

            require("ufo").setup({
                fold_virt_text_handler = handler,
            })
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

            -- This can't be setup in `keys` because we want to override the default `f` and `F` mappings.
            vim.keymap.set({ "n", "x", "o" }, "f", function()
                require("flash").jump()
            end, { desc = "Flash", noremap = true })

            vim.keymap.set({ "n", "x", "o" }, "F", function()
                require("flash").treesitter()
            end, { desc = "Flash Treesitter", noremap = true })
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
        init = function()
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
        opts = {
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
                -- ...
            },
            --]]
        },
        keys = {
            {
                "<Leader>sr",
                ":GrugFar<CR>",
                mode = { "n", "v" },
                desc = "Search and Replace",
                noremap = true,
            },
            {
                "<Leader>sR",
                ":GrugFarWithin<CR>",
                mode = "v",
                desc = "Replace within selection",
                noremap = true,
            },
        },
    },
}
