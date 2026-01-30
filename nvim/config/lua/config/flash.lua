vim.keymap.set({ "n", "x", "o" }, "f", function()
    require("flash").jump()
end, { desc = "Flash", noremap = true })

vim.keymap.set({ "n", "x", "o" }, "F", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter", noremap = true })
