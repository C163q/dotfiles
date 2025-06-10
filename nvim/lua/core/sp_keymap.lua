
-- keymap ONLY for dap-float
vim.api.nvim_create_augroup('EasyExitWindow', { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = 'EasyExitWindow',
    pattern = { "dap-float" },
    callback = function()
        vim.schedule(function ()
           vim.keymap.set("", "q", "<Cmd>q<CR>", { buffer = true, noremap = true })
           vim.keymap.set("", ".", "<Cmd>q<CR>", { buffer = true, noremap = true })
        end)
    end
})


vim.keymap.set("", '<Leader>v', function ()
        vim.cmd('Inspect')
    end,
    { noremap = true })

