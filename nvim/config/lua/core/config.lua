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
