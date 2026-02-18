local browser = require("core.config").browser

return {
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    -- render-markdown.nvim: Plugin to improve viewing Markdown files in Neovim
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        version = "*",
    },

    -- https://github.com/iamcco/markdown-preview.nvim
    -- markdown-preview.nvim: Markdown Preview for (Neo)vim
    {
        "iamcco/markdown-preview.nvim",
        -- Start the preview
        -- :MarkdownPreview
        -- Stop the preview
        -- :MarkdownPreviewStop
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            vim.g.mkdp_browser = browser
        end,
        ft = { "markdown" },
    },
}
