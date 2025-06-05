return {
    -- https://github.com/L3MON4D3/LuaSnip
    {
    	"L3MON4D3/LuaSnip",
    	-- follow latest release.
	    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        dependencies = { "rafamadriz/friendly-snippets" },
    },

    -- https://github.com/hrsh7th/nvim-cmp
    -- nvim-cmp: A completion engine plugin for neovim written in Lua.
    -- Completion sources are installed from external repositories and "sourced".
    {
        "hrsh7th/nvim-cmp",
        opts = {},
    },
    
    -- https://github.com/hrsh7th/cmp-nvim-lsp
    -- cmp-nvim-lsp: nvim-cmp source for neovim's built-in language server client.
    {
        "hrsh7th/cmp-nvim-lsp"
    },
    
    -- https://github.com/saadparwaiz1/cmp_luasnip
    {
        "saadparwaiz1/cmp_luasnip"
    },

    -- https://github.com/rafamadriz/friendly-snippets
    -- Friendly Snippets: Snippets collection for a set of different programming languages.
    {
        "rafamadriz/friendly-snippets"
    },
    
    -- https://github.com/hrsh7th/cmp-path
    {
        "hrsh7th/cmp-path"
    },
}
