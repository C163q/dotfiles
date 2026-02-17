local event_presets = require("core.config").event_presets

return {
    -- https://github.com/nvim-lualine/lualine.nvim
    -- lualine: A blazing fast and easy to configure Neovim statusline written in Lua.
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local indent_size = function()
                return vim.opt.shiftwidth:get()
            end
            require("lualine").setup({
                sections = {
                    lualine_c = {
                        {
                            "filename",
                            file_status = true,
                            newfile_status = true,
                            path = 0,

                            shorting_target = 40,
                            symbols = {
                                modified = "[+]",
                                readonly = "[-]",
                                unnamed = "[No Name]",
                                newfile = "[New]",
                            },
                        },
                    },
                    lualine_x = {
                        { "copilot", show_colors = true, show_loading = true },
                        "encoding",
                        "overseer",
                    },
                    lualine_y = { "filetype", indent_size },
                    lualine_z = { "progress", "location" },
                },
                options = {
                    theme = "catppuccin",
                    -- ... the rest of your lualine config
                    disabled_filetypes = {  -- Filetypes to disable lualine for.
                        -- only ignores the ft for statusline.
                        statusline = {
                            "neo-tree"
                        },
                        -- only ignores the ft for winbar.
                        winbar = {},
                    },
                },
            })
        end,
        event = event_presets.start_edit,
    },

    -- https://github.com/akinsho/bufferline.nvim
    -- bufferline.nvim: A snazzy buffer line (with tabpage integration) for Neovim built using lua.
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
        config = function()
            require("bufferline").setup({
                options = {
                    close_command = "bdelete! %d",
                    hover = {
                        enabled = true,
                        delay = 100,
                        reveal = { "close" },
                    },
                    indicator = {
                        style = "underline",
                        icon = "_",
                    },
                    pick = {
                        alphabet = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                    },
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local bufferline_icon = require("core.config").icon.bufferline
                        local s = ""
                        for e, n in pairs(diagnostics_dict) do
                            local sym = e == "error" and bufferline_icon.error
                                or (e == "warning" and bufferline_icon.warn or bufferline_icon.info)
                            s = s .. n .. sym
                        end
                        return s
                    end,
                    -- 左侧让出 nvim-tree 的位置
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "File Explorer",
                            highlight = "Directory",
                            text_align = "center",
                        },
                        {
                            filetype = "codecompanion",
                            text = "AI Chat",
                            highlight = "Directory",
                            text_align = "center",
                        },
                    },
                    custom_filter = function(buf_number, buf_numbers)
                        -- filter out filetypes you don't want to see
                        if vim.bo[buf_number].filetype ~= "neotree" and
                            vim.bo[buf_number].filetype ~= "checkhealth" and
                            vim.bo[buf_number].filetype ~= "grug-far" and
                            vim.bo[buf_number].filetype ~= "grug-far-history" and
                            vim.bo[buf_number].buftype ~= "terminal" and
                            vim.bo[buf_number].buftype ~= "quickfix" then
                            return true
                        end
                        return false
                    end,
                },
                highlights = require("catppuccin.special.bufferline").get_theme(),
            })
            require('config.bufferline')
        end,
    },

    -- https://github.com/folke/noice.nvim
    -- Noice (Nice, Noise, Notice): Highly experimental plugin that
    -- completely replaces the UI for messages, cmdline and the popupmenu.
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        config = function()
            require("noice").setup({
                -- add any options here
                --[[
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                },
                --]]
                presets = {
                    bottom_search = false, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
                messages = {
                    -- NOTE: If you enable messages, then the cmdline is enabled automatically.
                    -- This is a current Neovim limitation.
                    enabled = true, -- enables the Noice messages UI
                    view = "mini", -- view for messages
                    view_error = "mini", -- view for errors
                    view_warn = "mini", -- view for warnings
                    view_history = "messages", -- view for :messages
                    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
                },
                popupmenu = {
                    enabled = false,
                },
                lsp = {
                    signature = {
                        enabled = false,
                    },
                    progress = {
                        enabled = false,
                    },
                    hover = {
                        enabled = false,
                    },
                },
            })
            require("telescope").load_extension("noice")
        end,
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },

    -- https://github.com/j-hui/fidget.nvim
    -- Extensible UI for Neovim notifications and LSP progress messages.
    {
        "j-hui/fidget.nvim",
        opts = {},
        version = "*",
        event = event_presets.start_edit,
    }
}
