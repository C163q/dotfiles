local event_presets = require('core.config').event_presets

return {
    -- https://github.com/copilotlsp-nvim/copilot-lsp
    -- Copilot LSP: Copilot LSP Configuration for Neovim
    {
        "copilotlsp-nvim/copilot-lsp",
        event = event_presets.load_ai,
        config = function ()
            vim.g.copilot_nes_debounce = 500
            vim.lsp.enable("copilot_ls")
            vim.keymap.set("n", "<Tab>", function()
                local bufnr = vim.api.nvim_get_current_buf()
                local state = vim.b[bufnr].nes_state
                if state then
                    -- Try to jump to the start of the suggestion edit.
                    -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
                    local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
                        or (
                            require("copilot-lsp.nes").apply_pending_nes()
                            and require("copilot-lsp.nes").walk_cursor_end_edit()
                        )
                    return nil
                else
                    -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
                    return "<C-i>"
                end
            end, { desc = "Accept Copilot NES suggestion", expr = true })
        end
    },

    -- https://github.com/zbirenbaum/copilot.lua
    -- copilot.lua: This plugin is the pure lua replacement for github/copilot.vim.
    {
    	"zbirenbaum/copilot.lua",
        dependencies = { "copilotlsp-nvim/copilot-lsp" },   -- (optional) for NES functionality
        event = event_presets.load_ai,
        config = function ()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
                filetypes = {
                    markdown = false,
                    help = false,
                },
                disable_limit_reached_message = true,  -- Set to `true` to suppress completion limit reached popup
            })
        end
    },

    -- https://github.com/fang2hou/blink-copilot
    -- blink-copilot: Configurable GitHub Copilot blink.cmp source
    {
        "fang2hou/blink-copilot",
        dependencies = { "zbirenbaum/copilot.lua" },
        event = event_presets.load_ai,
        config = {}
    },

    -- https://github.com/AndreM222/copilot-lualine
    -- copilot-lualine: Component for lualine with the purpose of recieving and previewing status of copilot.lua
    {
        'AndreM222/copilot-lualine',
        dependencies = {
            "nvim-lualine/lualine.nvim",
        },
        event = event_presets.load_ai,
    },

    -- https://github.com/ravitemer/mcphub.nvim
    -- MCP HUB: MCP Hub is a MCP client for neovim that seamlessly integrates MCP (Model Context Protocol) servers
    -- into your editing workflow. It provides an intuitive interface for managing, testing, and
    -- using MCP servers with your favorite chat plugins.
    {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "bundled_build.lua",    -- Bundles `mcp-hub` binary along with the neovim plugin
        config = function()
            require("mcphub").setup({
                use_bundled_binary = true   -- Use local `mcp-hub` binary
            })
        end,
        event = event_presets.start_edit,
    },

    -- https://github.com/olimorris/codecompanion.nvim
    -- CodeCompanion: Code with LLMs and Agents via the in-built adapters,
    -- the community adapters or by building your own
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim", branch = "master" },
            "nvim-treesitter/nvim-treesitter",
            "ravitemer/mcphub.nvim",
            "ravitemer/codecompanion-history.nvim",
        },
        config = function ()
            require("codecompanion").setup({
                extensions = {
                    mcphub = {
                        callback = "mcphub.extensions.codecompanion",
                        opts = {
                            make_vars = true,
                            make_slash_commands = true,
                            show_result_in_chat = true
                        }
                    },
                    history = {
                        enabled = true,
                        opts = {
                            keymap = "<Leader>ah",  -- Keymap to open history from chat buffer (default: gh)
                            save_chat_keymap = "<Leader>as", -- Keymap to save the current chat manually
                            auto_save = false, -- Save all chats by default
                            expiration_days = 0,    -- Number of days after which chats are automatically deleted (0 to disable)
                            picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
                            picker_keymaps = {
                                rename = { n = "r", i = "<M-r>" },
                                delete = { n = "d", i = "<M-d>" },
                                duplicate = { n = "<C-y>", i = "<C-y>" },
                            },
                            ---Directory path to save the chats
                            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
                            -- Summary system
                            summary = {
                                -- Keymap to generate summary for current chat (default: "gcs")
                                create_summary_keymap = "<Leader>aU",
                                -- Keymap to browse summaries (default: "gbs")
                                browse_summaries_keymap = "<Leader>au",
                            },
                        }
                    }
                },
                display = {
                    action_palette = {
                        width = 95,
                        height = 20,
                        prompt = "Prompt ", -- Prompt used for interactive LLM calls
                        provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
                        opts = {
                            show_default_actions = true, -- Show the default actions in the action palette?
                            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
                            title = "CodeCompanion actions", -- The title of the action palette
                        },
                    },
                    chat = {
                        -- Extend/override the child_window options for a diff
                        diff_window = {
                            ---@return number|fun(): number
                            width = function()
                                return math.min(120, vim.o.columns - 10)
                            end,
                            ---@return number|fun(): number
                            height = function()
                                return vim.o.lines - 4
                            end,
                            opts = {
                                number = true,
                            },
                        },
                    },
                    diff = {
                        enabled = true,
                        provider = "mini_diff", -- mini_diff|split|inline

                        provider_opts = {
                            -- Options for inline diff provider
                            inline = {
                                layout = "float", -- float|buffer - Where to display the diff

                                diff_signs = {
                                    signs = {
                                        text = "▌", -- Sign text for normal changes
                                        reject = "✗", -- Sign text for rejected changes in super_diff
                                        highlight_groups = {
                                            addition = "DiagnosticOk",
                                            deletion = "DiagnosticError",
                                            modification = "DiagnosticWarn",
                                        },
                                    },
                                    -- Super Diff options
                                    icons = {
                                        accepted = " ",
                                        rejected = " ",
                                    },
                                    colors = {
                                        accepted = "DiagnosticOk",
                                        rejected = "DiagnosticError",
                                    },
                                },

                                opts = {
                                    context_lines = 3, -- Number of context lines in hunks
                                    dim = 25, -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
                                    full_width_removed = true, -- Make removed lines span full width
                                    show_keymap_hints = true, -- Show "gda: accept | gdr: reject" hints above diff
                                    show_removed = true, -- Show removed lines as virtual text
                                },
                            },

                            -- Options for the split provider
                            split = {
                                close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
                                layout = "vertical", -- vertical|horizontal split
                                opts = {
                                    "internal",
                                    "filler",
                                    "closeoff",
                                    "algorithm:histogram", -- https://adamj.eu/tech/2024/01/18/git-improve-diff-histogram/
                                    "indent-heuristic", -- https://blog.k-nut.eu/better-git-diffs
                                    "followwrap",
                                    "linematch:120",
                                },
                            },
                        },
                    },
                },
                strategies = {
                    chat = {
                        opts = {
                            ---Decorate the user message before it's sent to the LLM
                            ---@param message string
                            ---@param adapter CodeCompanion.Adapter
                            ---@param context table
                            ---@return string
                            prompt_decorator = function(message, adapter, context)
                                return string.format([[<prompt>%s</prompt>]], message)
                            end,
                        }
                    },
                    inline = {
                        keymaps = {
                            accept_change = {
                                modes = { n = "<Leader>aA" }, -- Remember this as DiffAccept
                            },
                            reject_change = {
                                modes = { n = "<Leader>aD" }, -- Remember this as DiffReject
                            },
                            always_accept = {
                                modes = { n = "<Leader>aY" }, -- Remember this as DiffYolo
                            },
                        },
                    },
                }
            })
            require("config.ai.codecompanion")
        end,
        event = event_presets.load_ai,
        version = "*",
    },

    -- https://github.com/Davidyz/VectorCode
    -- VectorCode: VectorCode is a code repository indexing tool. It helps you build better prompt for
    -- your coding LLMs by indexing and providing information about the code repository you're working on.
    {
        "Davidyz/VectorCode",
        version = "*",
        build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
        -- build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
        dependencies = { "nvim-lua/plenary.nvim" },
        event = event_presets.load_ai,
    },


    -- https://github.com/ravitemer/codecompanion-history.nvim
    -- CodeCompanion History Extension: A history management extension for codecompanion.nvim that
    -- enables saving, browsing and restoring chat sessions.
    {
        "ravitemer/codecompanion-history.nvim",
        dependencies = {
            "Davidyz/VectorCode",
            "folke/snacks.nvim",
        },
        event = event_presets.load_ai,
    },
}

