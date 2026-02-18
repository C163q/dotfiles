local catppuccin_flavour = require("core.config").flavour

return {
    -- https://github.com/catppuccin/nvim
    -- Catppuccin for (Neo)vim
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                float = {
                    transparent = false, -- enable transparent floating windows
                    solid = false, -- use solid styling for floating windows, see |winborder|
                },
                custom_highlights = function()
                    return {
                        RainbowRed = { fg = "#D66F77" },
                        RainbowYellow = { fg = "#D5C356" },
                        RainbowBlue = { fg = "#459EE6" },
                        RainbowOrange = { fg = "#E0A57E" },
                        RainbowGreen = { fg = "#98C379" },
                        RainbowViolet = { fg = "#C678DD" },
                        RainbowCyan = { fg = "#56B6C2" },
                    }
                end,
                flavour = catppuccin_flavour,
                styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
                    -- Change the style of comments
                },
                -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead.
                -- Should work with the standard **StatusLine** and **LuaLine**.
                hide_inactive_statusline = true,
                integrations = {
                    blink_cmp = {
                        style = "bordered",
                    },
                    dap = true,
                    dap_ui = true,
                    flash = true,
                    -- gitsigns = true,
                    grug_far = true,
                    lsp_trouble = true,
                    mini = {
                        enabled = true,
                        indentscope_color = "",
                    },
                    mason = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = {},
                            hints = {},
                            warnings = {},
                            information = {},
                            ok = {},
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
                    neotree = true,
                    -- notify = false,
                    snacks = {
                        enabled = true,
                    },
                    treesitter = true,
                    treesitter_context = true,
                    ufo = true,
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
                                ---@diagnostic disable-next-line
                                fg = colors.darkgreen,
                            },
                            Enums = {
                                ---@diagnostic disable-next-line
                                fg = colors.darkgreen,
                            },
                            EscapeSequences = {
                                fg = colors.rosewater,
                            },
                            Regex = {
                                fg = colors.rosewater,
                            },
                            Macros = {
                                fg = colors.pink,
                            },
                            Keyword = {
                                fg = colors.mauve,
                            },
                        }
                    end,
                },
                color_overrides = {
                    mocha = {
                        text = "#e4eff4",
                    },
                },
            })
            vim.cmd.colorscheme("catppuccin-mocha")
        end,
    },
}
