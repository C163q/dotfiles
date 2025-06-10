
return {
    --[[
    -- https://github.com/olimorris/onedarkpro.nvim
    -- onedarkpro colorscheme
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme onedark")
        end
    },
    --]]

    -- https://github.com/catppuccin/nvim
    -- Catppuccin for (Neo)vim
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "Mocha",
                styles = {  -- Handles the styles of general hi groups (see `:h highlight-args`):
                    comments = { "italic" },    -- Change the style of comments
                },
                -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead.
                -- Should work with the standard **StatusLine** and **LuaLine**.
                hide_inactive_statusline = true,
                integrations = {
                    cmp = true,
                    -- gitsigns = true,
                    -- nvimtree = true,
                    treesitter = true,
                    -- notify = false,
                    mini = {
                        enabled = true,
                        indentscope_color = "",
                    },
                    mason = true,
                    neotree = true,
                    dap = true,
                    dap_ui = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                            ok = { "italic" },
                        },
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "undercurl" },
                            warnings = { "undercurl" },
                            information = { "undercurl" },
                            ok = { "undercurl" },
                        },
                        inlay_hints = {
                            background = true,
                        },
                    },
                    ufo = true,
                    telescope = {
                        enabled = true,
                        -- style = "nvchad"
                    },
                    which_key = false,
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },
                highlight_overrides = {
                    all = function(colors)
                        return {
                            Function = {
                                fg = colors.yellow,
                            },
                            Methods = {
                                fg = colors.yellow,
                            },
                            Parameter = {
                                fg = colors.sky,
                            },
                            Operators = {
                                fg = colors.text,
                            },
                            Classes = {
                                fg = colors.darkgreen,
                            },
                            Enums = {
                                fg = colors.darkgreen,
                            },
                            EscapeSequences = {
                                fg = colors.rosewater,
                            },
                            Regex = {
                                fg = colors.rosewater,
                            },
                            Macros = {
                                fg = colors.pink
                            },
                            Keyword = {
                                fg = colors.mauve,
                            }
                        }
                    end
                },
                color_overrides = {
                    mocha = {
                        text = "#e4eff4",
                    },
                }
            })
            vim.cmd.colorscheme "catppuccin-mocha"
        end
    },
}

