return {
    -- https://github.com/rafamadriz/friendly-snippets
    -- Friendly Snippets: Snippets collection for a set of different programming languages.
    {
        "rafamadriz/friendly-snippets"
    },

    -- https://github.com/L3MON4D3/LuaSnip
    {
    	"L3MON4D3/LuaSnip",
    	-- follow latest release.
	    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        dependencies = { "rafamadriz/friendly-snippets" },
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
                    selection = { preselect = false, auto_insert = true },
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
            },
            keymap = {
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
                ['<C-g>'] = { 'scroll_documentation_up', 'fallback' },

                ['<C-s>'] = { 'hide' },
                ['<C-b>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },

                ['<CR>'] = { 'accept', 'fallback' },
                ['<C-y>'] = { 'select_and_accept' },

                ['<S-Up>'] = { 'snippet_backward', 'fallback' },
                ['<S-Down>'] = { 'snippet_forward', 'fallback' },

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
        },
    }

}
