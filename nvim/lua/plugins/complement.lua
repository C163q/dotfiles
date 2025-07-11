return {
    -- https://github.com/rafamadriz/friendly-snippets
    -- Friendly Snippets: Snippets collection for a set of different programming languages.
    {
        "rafamadriz/friendly-snippets",
        event = { 'BufReadPost', 'BufNewFile' },
    },

    -- https://github.com/L3MON4D3/LuaSnip
    {
    	"L3MON4D3/LuaSnip",
    	-- follow latest release.
	    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        dependencies = { "rafamadriz/friendly-snippets" },
        event = { 'BufReadPost', 'BufNewFile' },
        config = function ()
            require('config.complement.luasnip')
        end
    },

    -- https://github.com/folke/lazydev.nvim
    -- lazydev.nvim is a plugin that properly configures LuaLS for editing your Neovim config
    -- by lazily updating your workspace libraries.
    ---@Warning: NOT compatible with folke/neodev.nvim!!!!!!!
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- https://github.com/Saghen/blink.cmp
    -- Blink Completion (blink.cmp): Performant, batteries-included completion plugin for Neovim
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets', "L3MON4D3/LuaSnip", { 'xzbdmw/colorful-menu.nvim', opts = {} } },
        event = { 'BufReadPost', 'BufNewFile' },
        version = '1.*',
        opts = {
            completion = {
                documentation = {
                    auto_show = true,
                },
                list = {
                    selection = { preselect = false, auto_insert = false },
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
                }
            },
            keymap = {
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
                ['<C-g>'] = { 'scroll_documentation_up', 'fallback' },

                ['<C-s>'] = { 'hide' },
                ['<C-b>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

                ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },

                ['<CR>'] = { 'accept', 'fallback' },
                ['<C-y>'] = { 'select_and_accept' },

                ['<C-Left>'] = { 'snippet_backward', 'fallback' },
                ['<C-Right>'] = { 'snippet_forward', 'fallback' },

                ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },

                -- override default configs
                ['<C-e>'] = { 'fallback' },
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
                        auto_show = true
                    },
                },
            },
            snippets = { preset = 'luasnip' },
            sources = {
                -- add lazydev to your completion providers
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            }
        },
    }

}
