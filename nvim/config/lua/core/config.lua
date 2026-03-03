return {
    -- ##########################
    -- #     Basic Settings     #
    -- ##########################
    relative_line_number = true,
    mapleader = " ",
    mapleader_compat = { -- additional keys that can be used as mapleader
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
    undo_file = true, -- https://neovim.io/doc/user/options.html#'undofile'
    undo_levels = 2000, -- https://neovim.io/doc/user/options.html#'undolevels'
    not_wsl = (os.getenv("WSL_INTEROP") == nil),

    -- ###########################
    -- #     Buffer Settings     #
    -- ###########################
    irreplaceable_windows = { -- These windows will not be replaced.
        filetypes = { "neo-tree", "dap-float" },
        buftypes = { "terminal", "quickfix" },
    },
    easy_exit_windows = { -- These windows can be easily exited by pressing "q" or "<ESC>".
        filetypes = { "Trans", "snipe-menu" },
        buftypes = { "quickfix" },
    },

    -- ###########################
    -- #     Plugin Settings     #
    -- ###########################
    copilot = {
        -- Since it is async, error may occur when the original content is changed.
        -- I recommend to disable it if you don't need it.
        enable_nes = false,
        enable_immediate_suggestions = false,
    },
    browser = "", -- Default browser. Empty string means using system default browser.
    flavour = "mocha", -- catppuccin theme flavour
    ufo_plugin_ignore = { -- UFO plugin will be disabled in these filetypes and buftypes.
        filetypes = { "neo-tree", "notify", "snacks_dashboard" },
        buftypes = {},
    },
    bufferline_filter = { -- These buffers will be filtered out from the bufferline.
        filetypes = { "neo-tree", "checkhealth", "grug-far", "grug-far-history" },
        buftypes = { "terminal", "quickfix" },
    },
    treesitter = {
        -- Languages to install parsers for.
        -- See [supported languages](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md)
        -- for a complete list of supported languages.
        languages = {
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
            "zig",
            "css",
            "html",
            "latex",
            "scss",
            "tsx",
            "vue",
            "go",
        },
        features = {
            indent = {
                enable = true,
                disable = {},
            },
            highlight = {
                enable = true,
                -- treesiiter will override clangd's highlight
                disable = { "c", "cpp" },
            },
            fold = {
                enable = true,
            },
        },
    },
    navic = {
        separator = "  ", -- separator for navic component
    },

    -- ##########################
    -- #      LSP Settings      #
    -- ##########################
    lsp_list = {
        "lua_ls",
        "clangd",
        "basedpyright",
        "asm_lsp",
        "neocmake",
        "rust-analyzer",
        "gopls",
        "zls",
    },
    lsp_skip_enable = {
        "rust-analyzer", -- This is enabled by rustaceanvim, so we skip it here to avoid conflicts.
    },
    mason_install = { -- If you already install it globally, avoid adding it here.
        "basedpyright",
        "bashls",
        -- "clangd",
        "jdtls",
        "jsonls",
        "lua_ls",
        "vtsls",
        "asm_lsp",
        "neocmake",
    },
    basedpyright = {
        disable_annotation_missing_check = true,
        unused_warning = true,
        deprecated_warning = true,
        allow_unused_return = true,
    },

    -- ###########################
    -- #         Presets         #
    -- ###########################
    event_presets = {
        start_edit = { "BufReadPost", "BufNewFile", "BufWritePre" },
        start_insert = { "InsertEnter" },
        load_ai = { "InsertEnter" },
    },
    home_path = os.getenv("HOME"),
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
