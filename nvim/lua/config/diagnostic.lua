local api = vim.api

vim.diagnostic.config({
  virtual_text = true
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus=false, focusable = false })]]

-- CursorHoldI will show diagnostics on Insert mode
vim.api.nvim_create_autocmd({ 'CursorHold', --[['CursorHoldI'--]] }, {
    pattern = '*',
    callback = function()
        vim.diagnostic.open_float(nil, { focus=false, focusable = false })
    end,
})


