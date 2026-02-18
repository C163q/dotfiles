return {
    -- LSP Settings
    basedpyright_disable_annotation_missing_check = true,
    basedpyright_unused_warning = true,
    basedpyright_deprecated_warning = true,
    basedpyright_allow_unused_return = true,

    -- Basic Settings
    relative_line_number = true,
    mapleader = " ",
    mapleader_compat = {
        enable = true,
        value = ",",
    },
    search_ingore_case = false,
    trailing_whitespace_highlight = {
        enable = true,
        highlight_color = "#800000",
        highlight_cterm_color = "red",
        -- toggleterm's vim.bo.buftype is empty when opening for the first time,
        -- and then changes to "terminal".
        disabled_filetypes = { "toggleterm" },
    },
    flavour = "mocha", -- catppuccin theme flavour
    undo_file = true, -- https://neovim.io/doc/user/options.html#'undofile'
    undo_levels = 2000, -- https://neovim.io/doc/user/options.html#'undolevels'

    -- Buffer Settings
    irreplaceable_windows = {
        filetypes = { "neo-tree", "dap-float" },
        buftypes = { "terminal", "quickfix" },
    },
    ufo_plugin_ignore = {
        filetypes = { "neo-tree", "notify", "snacks_dashboard" },
        buftypes = {},
    },
    easy_exit_windows = {
        filetypes = { "Trans", "snipe-menu" },
        buftypes = { "quickfix" },
    },
    bufferline_filter = {
        filetypes = { "neo-tree", "checkhealth", "grug-far", "grug-far-history" },
        buftypes = { "terminal", "quickfix" },
    },

    -- Since it is async, error may occur when the original content is changed.
    -- I recommend to disable it if you don't need it.
    enable_copilot_nes = false,
    enable_copilot_immediate_suggestions = false,

    -- Default browser. empty string means using system default browser.
    browser = "",

    -- Environment Settings
    home_path = os.getenv("HOME"),

    -- Presets
    event_presets = {
        start_edit = { "BufReadPost", "BufNewFile", "BufWritePre" },
        start_insert = { "InsertEnter" },
        load_ai = { "InsertEnter" },
    },
    icon = {
        diagnostics = {
            warn = "",
            error = "",
            info = "",
            hint = "󰌶",
        },
        git_status = {
            added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = "✖", -- this can only be used in the git_status source
            renamed = "󰁕", -- this can only be used in the git_status source
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
        },
        bufferline = {
            error = " ",
            warn = " ",
            info = " ",
        },
        keys = {
            Up = "↑ ",
            Down = "↓ ",
            Left = "← ",
            Right = "→ ",
            C = "󰘴 ",
            M = "󰘳 ",
            S = "󰘶 ",
            CR = "󰌑 ",
            Esc = "󱊷 ",
            ScrollWheelDown = "󱕐 ",
            ScrollWheelUp = "󱕑 ",
            NL = "󰼧",
            BS = "󰌍 ",
            Space = "󱁐 ",
            Tab = "󰌒 ",
        },
    },
}
