-- Open terminal (not default) when press <Leader>t
vim.keymap.set("", "<Leader>tt", ":ToggleTerm<CR>", {
    noremap = true,
    desc = "Open terminal (not default)",
})

-- Open new terminal (not toggle) when press <Leader>\
vim.keymap.set("", "<Leader>\\", '<Cmd>exe v:count1 . "ToggleTerm"<CR>', {
    noremap = true,
    desc = "Open terminal#n decided by number prefix",
})

vim.keymap.set("", "<Leader>tS", "<Cmd>TermSelect<CR>", {
    noremap = true,
    desc = "Select Terminal with input",
})

vim.keymap.set("", "<Leader>ts", '<Cmd>exe v:count1 . "TermSelect"<CR>', {
    noremap = true,
    desc = "Select #n terminal decided by number prefix",
})
