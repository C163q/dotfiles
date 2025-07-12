vim.opt.termguicolors = true
vim.opt.mouse:append("a")

return {
    -- https://github.com/nvim-lualine/lualine.nvim
    -- lualine: A blazing fast and easy to configure Neovim statusline written in Lua.
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            sections = {
                lualine_c = {
                    {
                        'filename',
                        file_status = true,
                        newfile_status = true,
                        path = 0,

                        shorting_target = 40,
                        symbols = {
                            modified = '[+]',
                            readonly = '[-]',
                            unnamed = '[No Name]',
                            newfile = '[New]',
                        }
                    }
                }
            },
            options = {
                theme = "catppuccin"
                -- ... the rest of your lualine config
            }
        },
        event = { 'BufReadPost', 'BufNewFile' },
    },

    -- https://github.com/nvim-neo-tree/neo-tree.nvim
    -- Neo-tree is a Neovim plugin to browse the file system and other tree like structures in whatever style suits you,
    -- including sidebars, floating windows, netrw split style, or all of them at once!
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        lazy = false, -- neo-tree will lazily load itself
        config = function ()
            local git_status_icon = require('core.config').icon.git_status
            require('neo-tree').setup {
                -- fill any relevant options here
                close_if_last_window = false,
                enable_git_status = true,
                default_component_configs = {
                    git_status = {
                        symbols = {
                            -- Change type
                            added = git_status_icon.added,  -- or "✚", but this is redundant info if you use git_status_colors on the name
                            modified = git_status_icon.modified,    -- or "", but this is redundant info if you use git_status_colors on the name
                            deleted = git_status_icon.deleted,  -- this can only be used in the git_status source
                            renamed = git_status_icon.renamed,  -- this can only be used in the git_status source
                            -- Status type
                            untracked = git_status_icon.untracked,
                            ignored = git_status_icon.ignored,
                            unstaged = git_status_icon.unstaged,
                            staged = git_status_icon.staged,
                            conflict = git_status_icon.conflict,
                        },
                    },
                    window = {
                        position = "left",
                        width = 0.18,
                    }
                }
            }
        end,
    },

    -- https://github.com/nvim-treesitter/nvim-treesitter/tree/main
    -- The nvim-treesitter plugin provides
    --   functions for installing, updating, and removing tree-sitter parsers;
    --   a collection of queries for enabling tree-sitter features built into Neovim for these languages;
    --   a staging ground for treesitter-based features considered for upstreaming to Neovim.
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ":TSUpdate",
        config = function()
            require('nvim-treesitter.config').setup(opts)
            require('nvim-treesitter').setup()

            local ensure_installed = {
                'rust', 'javascript', 'c', 'lua',
                'cmake', 'cpp', 'json', 'jsonc',
                'markdown', 'python', 'regex', 'yaml', 'bash'
            }

            require('nvim-treesitter').install(ensure_installed):wait(30000)

            -- enable highlight
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { '<filetype>' },
                callback = function() vim.treesitter.start() end,
            })

            -- enable folds
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

        end
    },

    -- https://github.com/nvim-treesitter/nvim-treesitter-context
    -- nvim-treesitter-context: Lightweight alternative to context.vim
    {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
            enable = true,  -- Enable this plugin (Can be enabled/disabled later via commands)
            multiwindow = false,    -- Enable multiwindow support.
            max_lines = 6,  -- How many lines the window should span. Values <= 0 mean no limit.
            min_window_height = 0,  -- Minimum editor window height to enable context. Values <= 0 mean no limit.
            line_numbers = true,
            multiline_threshold = 3,   -- Maximum number of lines to show for a single context
            trim_scope = 'inner', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
            -- Separator between context and content. Should be a single character string, like '-'.
            -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
            separator = nil,
            zindex = 20, -- The Z-index of the context window
            on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        },
        event = { 'BufReadPost', 'BufNewFile' },
    },

    -- https://github.com/akinsho/bufferline.nvim
    -- bufferline.nvim: A snazzy buffer line (with tabpage integration) for Neovim built using lua.
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                close_command = "bdelete! %d",
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = {'close'}
                },
                indicator = {
                    style = 'underline',
                    icon = "_"
                },
                pick = {
                    alphabet = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                },
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local bufferline_icon = require('core.config').icon.bufferline
                    local icon = level:match("error") and bufferline_icon.error or bufferline_icon.warn
                    return " " .. icon .. count
                end,
                -- 左侧让出 nvim-tree 的位置
                offsets = {{
                    filetype = "neo-tree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "center"
                }},
                custom_filter = function(buf_number, buf_numbers)
                    -- filter out filetypes you don't want to see
                    if vim.bo[buf_number].filetype ~= "neotree"
                        and vim.bo[buf_number].buftype ~= "terminal"
                    then
                        return true
                    end
                end,
            },
            highlights = require("catppuccin.groups.integrations.bufferline").get()
        }
    },

    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    -- render-markdown.nvim: Plugin to improve viewing Markdown files in Neovim
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown' },
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        version = "*",
    },

    -- https://github.com/akinsho/toggleterm.nvim
    -- toggleterm.nvim: A neovim plugin to persist and toggle multiple terminals during an editing session
    {
        'akinsho/toggleterm.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        version = "*",
        opts = {}
    },

    -- https://github.com/nvim-lua/plenary.nvim
    -- plenary.nvim: All the lua functions I don't want to write twice.
    {
        'nvim-lua/plenary.nvim',
        opt = {},
    },

    -- https://github.com/nvim-telescope/telescope.nvim
    -- telescope.nvim: Gaze deeply into unknown regions using the power of the moon.
    {
        'nvim-telescope/telescope.nvim',
        -- branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        event = 'VeryLazy',
        config = function ()
            require('config.telescope')
        end
    },

    -- https://github.com/kevinhwang91/nvim-ufo
    -- nvim-ufo: The goal of nvim-ufo is to make Neovim's fold look modern and keep high performance.
    {
        'kevinhwang91/nvim-ufo',
        event = 'VeryLazy',
        -- event = { 'BufReadPost', 'BufNewFile' }, -- Don't Lazy load to enable specific autocommands
        dependencies = { 'kevinhwang91/promise-async' },
        config = function()
            require('config.ufo')
        end
    },

--[[
    -- https://github.com/rcarriga/nvim-notify
    -- nvim-notify: A fancy, configurable, notification manager for NeoVim
    -- DISABLED for messages truncated when `max_width` set.
    {
        "rcarriga/nvim-notify",
        opts = {
            max_width = 30,
            max_height = 20,
            wrap_message = true,
        }
    },
--]]

    -- https://github.com/folke/noice.nvim
    -- Noice (Nice, Noise, Notice): Highly experimental plugin that 
    -- completely replaces the UI for messages, cmdline and the popupmenu.
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        config = function ()
            require('noice').setup {
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
                    bottom_search = false,  -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true,   -- long messages will be sent to a split
                    inc_rename = false,     -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true,  -- add a border to hover docs and signature help
                },
                messages = {
                    -- NOTE: If you enable messages, then the cmdline is enabled automatically.
                    -- This is a current Neovim limitation.
                    enabled = true,        -- enables the Noice messages UI
                    view = "mini",          -- view for messages
                    view_error = "mini",    -- view for errors
                    view_warn = "mini",     -- view for warnings
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
            }
            require("telescope").load_extension("noice")
        end,
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            "nvim-treesitter/nvim-treesitter",
        }
    },

    -- https://github.com/folke/snacks.nvim
    -- snacks.nvim: A collection of small QoL plugins for Neovim.
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = { enabled = true },
            indent = {
                enabled = true,
                indent = {
                    priority = 1,
                    enabled = true, -- enable indent guides
                    char = "│",
                    only_scope = false, -- only show indent guides of the scope
                    only_current = false, -- only show indent guides in the current window
                    hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
                },
                scope = {
                    enabled = true, -- enable highlighting the current scope
                    priority = 200,
                    char = "│",
                    underline = false, -- underline the start of the scope
                    only_current = false, -- only show scope in the current window
                    hl = {  ---@type string|string[] hl group for scopes
                        "RainbowRed",
                        "RainbowYellow",
                        "RainbowBlue",
                        "RainbowOrange",
                        "RainbowGreen",
                        "RainbowViolet",
                        "RainbowCyan",
                    }
                },
            },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = {  -- NOT good for using keyboard
                enabled = false,
            },
            statuscolumn = {    -- override by nvim-ufo
                enabled = true,
            },
            words = { enabled = true },
            lazygit = { enable = true },
            -- Can't use sixel for cost too much time rendering.
            --[[
            dashboard = {
                sections = {
                    {
                        section = "terminal",
                        cmd = "cat ~/custom/neovim/dashboard_ascii_art_1.txt; sleep .1s",
                        height = 14,
                        width = 30,
                        padding = 1,
                        indent = 20,
                    },
                    {
                        pane = 2,
                        { section = "header" },
                        { section = "keys", gap = 1, padding = 1 },
                        { section = "startup" },
                    },
                },
            }
            --]]
        },
        keys = {
            -- picker overwrite windows for winfixbuf is set!!!!!!
            -- May solve: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
            { "<leader>gf", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
            { "<leader>m", function() Snacks.picker.buffers() end, desc = "Buffers" },
            { "<leader>gn", function() Snacks.picker.notifications() end, desc = "Notification History" },
            { "<leader>g:", function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<leader>g/", function() Snacks.picker.grep() end, desc = "Grep" },
            { "<leader>ge", function() Snacks.explorer() end, desc = "File Explorer" },
            { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
            { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
            { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
            { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
            { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
            { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
            { "<leader>go", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
            { "gx", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
            { "gX", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
            { "gR", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
            { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
            { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
            { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
            { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
            { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
            { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
            { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
            { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
            { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
            { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
            { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
            { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
            { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
            { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
            { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
            { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
            { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
            { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
            { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
            { "<leader>fB", function() Snacks.picker.buffers() end, desc = "Buffers" },
            { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
            { "<leader>fF", function() Snacks.picker.files() end, desc = "Find Files" },
            { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
            { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
            { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        },
        picker = {
            jump = {
                jumplist = true, -- save the current position in the jumplist
                tagstack = false, -- save the current position in the tagstack
                reuse_win = true, -- reuse an existing window if the buffer is already open
                close = true, -- close the picker when jumping/editing to a location (defaults to true)
                match = false, -- jump to the first match position. (useful for `lines`)
            },
        },
    }
}
