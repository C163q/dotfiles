local event_presets = require("core.config").event_presets

return {
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
        opts = {
            opts = {
                language = "Chinese",
            },
            extensions = {
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        make_vars = true,
                        make_slash_commands = true,
                        show_result_in_chat = true,
                    },
                },
                history = {
                    enabled = true,
                    opts = {
                        keymap = "gh", -- Keymap to open history from chat buffer (default: gh)
                        save_chat_keymap = "sc", -- Keymap to save the current chat manually
                        auto_save = false, -- Save all chats by default
                        expiration_days = 0, -- Number of days after which chats are automatically deleted (0 to disable)
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
                            create_summary_keymap = "gcs",
                            -- Keymap to browse summaries (default: "gbs")
                            browse_summaries_keymap = "gbs",
                        },
                    },
                },
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
                    },
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
            },
        },
        event = event_presets.load_ai,
        cmd = { "CodeCompanionChat", "CodeCompanionActions", "CodeCompanion" },
        keys = {
            {
                "<Leader>at",
                "<Cmd>CodeCompanionChat Toggle<CR>",
                noremap = true,
                desc = "Chat AI: Toggle window",
            },
            {
                "<Leader>ao",
                "<Cmd>CodeCompanionChat<CR>",
                noremap = true,
                desc = "Chat AI: Open window",
            },
            {
                "<Leader>ai",
                function()
                    local input = vim.fn.input("Prompt:")
                    vim.cmd("<Cmd>CodeCompanion " .. input .. "<CR>")
                end,
                noremap = true,
                desc = "Chat AI: Inline chat",
            },
            {
                "<Leader>ar",
                "<Cmd>CodeCompanionChat RefreshCache<CR>",
                noremap = true,
                desc = "Chat AI: Refresh chat elements buffer",
            },
            {
                "<Leader>aa",
                "<Cmd>CodeCompanionActions<CR>",
                noremap = true,
                desc = "Chat AI: Open panel",
            },
        },
        version = "*",
    },
}
