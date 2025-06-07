
vim.api.nvim_create_user_command('ComplieCommandsFix',
    function()
        vim.cmd('1,$s/"-ftree-loop-vectorize"/"-Rpass=loop-vectorize"/g')
        vim.cmd('1,$s/"-flto=[0-9]*"/"-flto=auto"/g')

        vim.cmd('w')
    end,
    { nargs = 0 }
)

vim.api.nvim_create_augroup('IrreplaceableWindows', { clear = true })
-- make windows impossible to be replaced
vim.api.nvim_create_autocmd('BufWinEnter', {
    group = 'IrreplaceableWindows',
    pattern = '*',
    callback = function()
        local filetypes = { 'neo-tree', 'notify' }
        local buftypes = { 'terminal', 'nofile' }
        if vim.tbl_contains(buftypes, vim.bo.buftype) or
            vim.tbl_contains(filetypes, vim.bo.filetype) then
            vim.cmd('set winfixbuf')
        end
    end
})

vim.api.nvim_create_augroup('NvimUFOIgnore', { clear = true })
-- nvim-ufo ignore filetype
vim.api.nvim_create_autocmd('FileType', {
    group = 'NvimUFOIgnore',
    pattern = { 'neo-tree', 'notify' },
    callback = function()
        require('ufo').detach()
        vim.opt_local.foldenable = false
        vim.opt_local.foldcolumn = '0'
    end,
})


