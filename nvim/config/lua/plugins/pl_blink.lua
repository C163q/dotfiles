local event_presets = require("core.config").event_presets

return {
    -- https://github.com/Saghen/blink.cmp
    -- Blink Completion (blink.cmp): Performant, batteries-included completion plugin for Neovim
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "L3MON4D3/LuaSnip",
            { "xzbdmw/colorful-menu.nvim", opts = {} },
            "fang2hou/blink-copilot",
        },
        event = event_presets.start_insert,
        version = "1.*",
        opts = {
            completion = {
                documentation = {
                    auto_show = true,
                },
                list = {
                    selection = { auto_insert = false },
                },
                menu = {
                    draw = {
                        -- We don't need label_description now because label and label_description are already
                        -- combined together in label by colorful-menu.nvim.
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
                ghost_text = {
                    enabled = true,
                },
            },
            keymap = {
                -- unknown bug that `"scroll_documentation_up"` doesn't work properly,
                -- but `cmp.scroll_documentation_up(num)` works fine.
                --
                -- unknown bug that you have to press `<C-g>` twice to scroll down.
                ["<C-f>"] = {
                    function(cmp)
                        cmp.scroll_documentation_up(5)
                    end,
                    "fallback",
                },
                ["<C-g>"] = {
                    function(cmp)
                        cmp.scroll_documentation_down(5)
                    end,
                    "fallback",
                },

                ["<C-s>"] = { "hide" },
                ["<C-b>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<C-Tab>"] = {
                    function(cmp)
                        return cmp.select_next({ count = 3 })
                    end,
                    "fallback",
                },
                ["<C-S-Tab>"] = {
                    function(cmp)
                        return cmp.select_prev({ count = 3 })
                    end,
                    "fallback",
                },

                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-Down>"] = {
                    function(cmp)
                        return cmp.select_next({ count = 3 })
                    end,
                    "fallback",
                },
                ["<C-Up>"] = {
                    function(cmp)
                        return cmp.select_prev({ count = 3 })
                    end,
                    "fallback",
                },

                ["<CR>"] = { "accept", "fallback" },
                ["<C-y>"] = { "select_and_accept" },

                ["<C-Left>"] = { "snippet_backward", "fallback" },
                ["<C-Right>"] = { "snippet_forward", "fallback" },

                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

                -- override default configs
                ["<C-e>"] = { "fallback" },
            },
            signature = {
                enabled = true,
            },
            cmdline = {
                completion = {
                    list = {
                        selection = { preselect = false, auto_insert = true },
                    },
                    menu = {
                        auto_show = true,
                    },
                },
            },
            snippets = {
                preset = "luasnip",
                -- SOLVE: snippet_forward is still triggerable after user has moved on
                -- see: https://github.com/Saghen/blink.cmp/issues/1805#issuecomment-2919327795
                active = function(filter)
                    local snippet = require("luasnip")
                    local blink = require("blink.cmp")
                    if snippet.in_snippet() and not blink.is_visible() then
                        return true
                    else
                        if not snippet.in_snippet() and vim.fn.mode() == "n" then
                            snippet.unlink_current()
                        end
                        return false
                    end
                end,
            },
            sources = {
                -- add lazydev to your completion providers
                default = { "copilot", "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    copilot = {
                        name = "Copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 96,
                        async = true,
                    },
                },
                per_filetype = {
                    codecompanion = { "codecompanion" },
                },
            },
        },
    },
}
