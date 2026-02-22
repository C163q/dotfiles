local config = require("core.config")

vim.api.nvim_create_user_command("ComplieCommandsFix", function()
    vim.cmd('1,$s/"-ftree-loop-vectorize"/"-Rpass=loop-vectorize"/g')
    vim.cmd('1,$s/"-flto=[0-9]*"/"-flto=auto"/g')

    vim.cmd("w")
end, { nargs = 0 })

vim.api.nvim_create_augroup("ConfigIrreplaceableWindows", { clear = true })
-- make windows impossible to be replaced
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = "ConfigIrreplaceableWindows",
    pattern = "*",
    callback = function()
        local filetypes_or = config.irreplaceable_windows.filetypes
        local buftypes_or = config.irreplaceable_windows.buftypes
        -- DO NOT put 'nofile' buftype HERE!!!!!!!!!!!!!!!!!!
        -- or snacks.picker WILL OVERWRITE current file for 'winfixbuf' set.
        if vim.tbl_contains(buftypes_or, vim.bo.buftype) or vim.tbl_contains(filetypes_or, vim.bo.filetype) then
            vim.cmd("set winfixbuf")
        end
    end,
})

vim.api.nvim_create_augroup("ConfigNvimUFOIgnore", { clear = true })
-- nvim-ufo ignore filetype
vim.api.nvim_create_autocmd("FileType", {
    group = "ConfigNvimUFOIgnore",
    pattern = "*",
    callback = function()
        local buftype = config.ufo_plugin_ignore.buftypes
        local filetype = config.ufo_plugin_ignore.filetypes
        if vim.tbl_contains(buftype, vim.bo.buftype) or vim.tbl_contains(filetype, vim.bo.filetype) then
            require("ufo").detach()
            vim.wo.foldenable = false
            vim.wo.foldcolumn = "0"
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

vim.api.nvim_create_augroup("ConfigWinEasyExitDapFloat", { clear = true })
-- make dap-float easy to exit
vim.api.nvim_create_autocmd("FileType", {
    group = "ConfigWinEasyExitDapFloat",
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

vim.api.nvim_create_augroup("ConfigWinEasyExitBufType", { clear = true })
-- make windows easy to exit
vim.api.nvim_create_autocmd("FileType", {
    group = "ConfigWinEasyExitBufType",
    pattern = "*",
    callback = function()
        local filetypes = config.easy_exit_windows.filetypes
        local buftypes = config.easy_exit_windows.buftypes
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

-- Highlight trailing whitespaces
-- inspired by [trim.nvim](https://github.com/cappyzawa/trim.nvim)
if config.trailing_whitespace_highlight.enable then
    local augroup = vim.api.nvim_create_augroup("ConfigTrailingWhitespaceHighlight", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        callback = function()
            -- vim.bo.buftype == '' means normal file buffer, not terminal, quickfix, etc.
            if
                vim.bo.buftype == ""
                and not vim.tbl_contains(config.trailing_whitespace_highlight.disabled_filetypes, vim.bo.filetype)
            then
                vim.fn.matchadd("ConfigTrailingWhitespace", "\\s\\+$")
            end
        end,
    })
    vim.api.nvim_set_hl(0, "ConfigTrailingWhitespace", {
        bg = config.trailing_whitespace_highlight.highlight_color,
        ctermbg = config.trailing_whitespace_highlight.highlight_cterm_color,
    })
end
