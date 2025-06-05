return {
    -- https://github.com/olimorris/onedarkpro.nvim
    -- onedarkpro colorscheme
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme onedark")
        end
    }
}
