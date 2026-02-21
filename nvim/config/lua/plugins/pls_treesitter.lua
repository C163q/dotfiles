local event_presets = require("core.config").event_presets
local treesitter_util = require("config.treesiiter")

return {
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
            -- You do not need to call setup for nvim-treesitter to work using default values.
            -- require("nvim-treesitter").setup()

            local treesitter = require("nvim-treesitter")
            local treesitter_config = require("core.config").treesitter
            local ensure_installed = treesitter_config.languages or {}

            -- **Reference**: configuration inspired by `LazyVim`
            treesitter_util.get_installed(true)

            -- install missing parsers
            local install = vim.tbl_filter(function(lang)
                return not treesitter_util.have(lang)
            end, ensure_installed or {})
            if #install > 0 then
                treesitter.install(install, { summary = true }):await(function()
                    treesitter_util.get_installed(true) -- refresh the installed langs
                end)
            end

            -- require("nvim-treesitter").install(ensure_installed):wait(30000)

            local features = treesitter_config.features or {}

            -- enable highlight
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("ConfigTreesitter", { clear = true }),
                callback = function(arg)
                    local ft, lang = arg.match, vim.treesitter.language.get_lang(arg.match)
                    if not treesitter_util.have(ft) then
                        return
                    end

                    local function enabled(feat, query)
                        local f = features[feat] or {}
                        return f.enable ~= false
                            and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
                            and treesitter_util.have(ft, query)
                    end

                    if enabled("highlight", "highlights") then
                        pcall(vim.treesitter.start, arg.buf)
                    end

                    -- vim.wo[{winid}][{bufnr}]:
                    -- Get or set window-scoped options for the window with handle {winid} and
                    -- buffer with number {bufnr}.
                    --
                    -- local winid = vim.api.nvim_get_current_win()
                    -- vim.wo[winid].number = true    -- same as vim.wo.number = true
                    --
                    -- Note: only {bufnr} with value 0 (the current buffer in the window) is supported.

                    -- vim.bo[{bufnr}]
                    -- Get or set buffer-scoped options for the buffer with number {bufnr}.
                    --
                    -- local bufnr = vim.api.nvim_get_current_buf()
                    -- vim.bo[bufnr].buflisted = true    -- same as vim.bo.buflisted = true

                    if enabled("indent", "indents") then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end

                    if enabled("folds", "folds") then
                        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                        vim.wo.foldmethod = "expr"
                    end
                end,
            })
        end,
    },

    -- https://github.com/nvim-treesitter/nvim-treesitter-context
    -- nvim-treesitter-context: Lightweight alternative to context.vim
    {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            multiwindow = false, -- Enable multiwindow support.
            max_lines = 6, -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 3, -- Maximum number of lines to show for a single context
            trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
            -- Separator between context and content. Should be a single character string, like '-'.
            -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
            separator = nil,
            zindex = 20, -- The Z-index of the context window
            on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        },
        event = event_presets.start_edit,
    },

    -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    -- nvim-treesitter-textobjects: Syntax aware text-objects, select, move, swap, and peek support.
    -- **Reference**: configuration from [`Lazyvim`](https://www.lazyvim.org/plugins/treesitter)
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = "VeryLazy",
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            -- vim.g.no_plugin_maps = true

            -- Or, disable per filetype (add as you like)
            -- vim.g.no_python_maps = true
            -- vim.g.no_ruby_maps = true
            -- vim.g.no_rust_maps = true
            -- vim.g.no_go_maps = true
        end,
        opts = {
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                -- LazyVim extention to create buffer-local keymaps
                keys = {
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]a"] = "@parameter.inner",
                    },
                    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[a"] = "@parameter.inner",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[A"] = "@parameter.inner",
                    },
                },
            },
        },
        config = function(_, opts)
            local TS = require("nvim-treesitter-textobjects")
            if not TS.setup then
                vim.notify("Please use `:Lazy` and update `nvim-treesitter`", vim.log.levels.WARN)
                return
            end
            TS.setup(opts)

            local function attach(buf)
                local ft = vim.bo[buf].filetype
                if not (vim.tbl_get(opts, "move", "enable") and treesitter_util.have(ft, "textobjects")) then
                    return
                end
                ---@type table<string, table<string, string>>
                local moves = vim.tbl_get(opts, "move", "keys") or {}

                for method, keymaps in pairs(moves) do
                    for key, query in pairs(keymaps) do
                        local queries = type(query) == "table" and query or { query }
                        local parts = {}
                        for _, q in ipairs(queries) do
                            local part = q:gsub("@", ""):gsub("%..*", "")
                            part = part:sub(1, 1):upper() .. part:sub(2)
                            table.insert(parts, part)
                        end
                        local desc = table.concat(parts, " or ")
                        desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
                        desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
                        if not (vim.wo.diff and key:find("[cC]")) then
                            vim.keymap.set({ "n", "x", "o" }, key, function()
                                require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
                            end, {
                                buffer = buf,
                                desc = desc,
                                silent = true,
                            })
                        end
                    end
                end
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("lazyvim_treesitter_textobjects", { clear = true }),
                callback = function(ev)
                    attach(ev.buf)
                end,
            })
            vim.tbl_map(attach, vim.api.nvim_list_bufs())
        end,
    },
}
