vim.api.nvim_create_user_command("ComplieCommandsFix", function()
    vim.cmd('1,$s/"-ftree-loop-vectorize"/"-Rpass=loop-vectorize"/g')
    vim.cmd('1,$s/"-flto=[0-9]*"/"-flto=auto"/g')

    vim.cmd("w")
end, { nargs = 0 })

vim.api.nvim_create_augroup("IrreplaceableWindows", { clear = true })
-- make windows impossible to be replaced
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = "IrreplaceableWindows",
    pattern = "*",
    callback = function()
        local filetypes_or = { "neo-tree", "dap-float" }
        local buftypes_or = { "terminal" }
        -- DO NOT put 'nofile' buftype HERE!!!!!!!!!!!!!!!!!!
        -- or snacks.picker WILL OVERWRITE current file for 'winfixbuf' set.
        if vim.tbl_contains(buftypes_or, vim.bo.buftype) or vim.tbl_contains(filetypes_or, vim.bo.filetype) then
            vim.cmd("set winfixbuf")
        end
    end,
})

vim.api.nvim_create_augroup("NvimUFOIgnore", { clear = true })
-- nvim-ufo ignore filetype
vim.api.nvim_create_autocmd("FileType", {
    group = "NvimUFOIgnore",
    pattern = "*",
    callback = function()
        local buftype = {}
        local filetype = { "neo-tree", "notify", "snacks_dashboard" }
        if vim.tbl_contains(buftype, vim.bo.buftype) or vim.tbl_contains(filetype, vim.bo.filetype) then
            require("ufo").detach()
            vim.opt_local.foldenable = false
            vim.opt_local.foldcolumn = "0"
        end
    end,
})

--[[
-- Prevent being truncated for noise 'view = mini'
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  group = curfile_augroup,
  pattern = '*',
  callback = function ()
    vim.api.nvim_win_set_option(0, 'winhl', '')
    -- vim.opt.signcolumn = 'yes' -- comment/delete this line fixes the problem!
  end,
})
--]]

vim.api.nvim_create_augroup("WinEasyExitDapFloat", { clear = true })
-- make dap-float easy to exit
vim.api.nvim_create_autocmd("FileType", {
    group = "WinEasyExitDapFloat",
    pattern = { "dap-float" },
    callback = function()
        local buffer_id = vim.fn.bufnr()
        vim.api.nvim_create_autocmd("WinLeave", {
            buffer = buffer_id,
            callback = function()
                vim.cmd("exit")
            end,
        })
        vim.keymap.set("", "q", function()
            vim.cmd("exit")
        end, { buffer = buffer_id, noremap = true })
        vim.keymap.set("", ".", function()
            vim.cmd("exit")
        end, { buffer = buffer_id, noremap = true })
        vim.keymap.set("n", "<Esc>", function()
            vim.cmd("exit")
        end, { buffer = buffer_id, noremap = true })
    end,
})

vim.api.nvim_create_augroup("WinEasyExitBufType", { clear = true })
-- make windows easy to exit
vim.api.nvim_create_autocmd("FileType", {
    group = "WinEasyExitBufType",
    pattern = "*",
    callback = function()
        local filetypes = {}
        local buftypes = { "quickfix" }
        if vim.tbl_contains(buftypes, vim.bo.buftype) or vim.tbl_contains(filetypes, vim.bo.filetype) then
            local buffer_id = vim.fn.bufnr()
            vim.keymap.set("n", "<Esc>", function()
                vim.cmd("exit")
            end, { buffer = buffer_id, noremap = true })
            vim.keymap.set("", "q", function()
                vim.cmd("exit")
            end, { buffer = buffer_id, noremap = true })
        end
    end,
})
