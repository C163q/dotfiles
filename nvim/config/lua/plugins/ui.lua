local event_presets = require("core.config").event_presets
local indent_size = function()
    return vim.opt.shiftwidth:get()
end

return {
    -- https://github.com/nvim-lualine/lualine.nvim
    -- lualine: A blazing fast and easy to configure Neovim statusline written in Lua.
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
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
            winbar = {
                lualine_c = {
                    {
                        function()
                            local navic = require("nvim-navic")
                            local sep = require("core.config").navic.separator or " > "
                            local text = navic.get_location()
                            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
                            local icon =
                                require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype, { default = true })
                            if text == "" then
                                return icon .. " " .. filename
                            else
                                return icon .. " " .. filename .. sep .. text
                            end
                        end,
                        cond = function()
                            local navic = require("nvim-navic")
                            return navic.is_available()
                        end,
                    },
                },
            },
            options = {
                theme = "catppuccin",
                -- ... the rest of your lualine config
                disabled_filetypes = { -- Filetypes to disable lualine for.
                    -- only ignores the ft for statusline.
                    statusline = {
                        "neo-tree",
                    },
                    -- only ignores the ft for winbar.
                    winbar = {},
                },
            },
        },
        event = event_presets.start_edit,
    },

    -- https://github.com/folke/noice.nvim
    -- Noice (Nice, Noise, Notice): Highly experimental plugin that
    -- completely replaces the UI for messages, cmdline and the popupmenu.
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
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
            commands = {
                allpop = {
                    view = "popup",
                    opts = { enter = true, format = "details" },
                    filter = {},
                },
            },
            views = {
                -- see https://github.com/folke/noice.nvim/blob/main/lua/noice/config/views.lua
                mini = {
                    timeout = 3000, -- timeout in ms
                },
            },
        },
        keys = {
            {
                "<Leader>em",
                "<Cmd>Noice allpop<CR>",
                desc = "Explore Messages (Noice)",
                noremap = true,
            },
        },
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
    },

    -- https://github.com/lukas-reineke/virt-column.nvim
    -- virt-column.nvim: Display a character as the colorcolumn.
    {
        "lukas-reineke/virt-column.nvim",
        event = event_presets.start_edit,
        config = (function()
            local enable = true
            return function()
                require("virt-column").setup({
                    enabled = enable,
                    char = "│",
                    virtcolumn = "100",
                })
                vim.keymap.set("n", "<Leader>vl", function()
                    enable = not enable
                    require("virt-column").update({
                        enabled = enable,
                    })
                end, { desc = "Toggle virtual column", noremap = true })
            end
        end)(),
    },

    -- https://github.com/nvim-zh/colorful-winsep.nvim
    -- colorful-winsep.nvim: configurable window separator
    {
        "nvim-zh/colorful-winsep.nvim",
        opts = {},
        event = { "WinLeave" },
    },

    -- https://github.com/SmiteshP/nvim-navic
    -- nvim-navic: A simple statusline/winbar component that uses LSP to show your current code context.
    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
        on_init = function()
            -- NOTE: You can set vim.g.navic_silence = true to supress error messages thrown by nvim-navic
            -- vim.g.navic_silence = true
        end,
        config = function()
            local navic = require("nvim-navic")

            local lsp_util = require("config.lsp.core")
            local lsp_list = require("core.config").lsp_list or {}
            for _, lsp_name in ipairs(lsp_list) do
                lsp_util.add_on_attach(lsp_name, function(client, bufnr)
                    if client.server_capabilities.documentSymbolProvider then
                        -- vim.notify("Attaching nvim-navic to " .. lsp_name, vim.log.levels.INFO, { title = "LSP Attach" })
                        navic.attach(client, bufnr)
                    end
                end)
            end

            navic.setup({
                highlight = true,
                separator = require("core.config").navic.separator or " > ",
                depth_limit = 5,
                depth_limit_indicator = "..",
                lazy_update_context = true,
            })
        end,
    },
}
