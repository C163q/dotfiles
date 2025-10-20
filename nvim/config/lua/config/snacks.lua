vim.keymap.set("n", "<Leader>gw", function()
    Snacks.lazygit.open()
end, { noremap = true, desc = "Open lazygit" })

vim.keymap.set("n", "<Leader>gg", function()
    Snacks.lazygit.log()
end, { noremap = true, desc = "Open lazygit with log view" })

vim.keymap.set("n", "<Leader>gG", function()
    Snacks.lazygit.log_file()
end, { noremap = true, desc = "Open lazygit with current log" })
