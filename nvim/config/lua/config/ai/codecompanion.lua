vim.keymap.set("n", "<Leader>at", "<Cmd>CodeCompanionChat Toggle<CR>", {
    noremap = true,
    desc = "Chat AI: Toggle window",
    silent = true,
})

vim.keymap.set("n", "<Leader>ao", "<Cmd>CodeCompanionChat<CR>", {
    noremap = true,
    desc = "Chat AI: Open window",
    silent = true,
})

vim.keymap.set("n", "<Leader>ai", function()
    local input = vim.fn.input("Prompt:")
    vim.cmd("<Cmd>CodeCompanion " .. input .. "<CR>")
end, {
    noremap = true,
    desc = "Chat AI: Inline chat",
    silent = true,
})

vim.keymap.set("n", "<Leader>ar", "<Cmd>CodeCompanionChat RefreshCache<CR>", {
    noremap = true,
    desc = "Chat AI: Refresh chat elements buffer",
    silent = true,
})

vim.keymap.set("n", "<Leader>aa", "<Cmd>CodeCompanionActions<CR>", {
    noremap = true,
    desc = "Chat AI: Open panel",
    silent = true,
})
