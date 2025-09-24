
-- On Neovim 0.11+ with vim.lsp.config, you may skip configuring LSP Capabilities.

require("luasnip.loaders.from_vscode").lazy_load()

-- https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1429989436
-- stop snippet when go to normal mode
-- Shouldn't going to normal mode cancel the "session"? #258
--
-- NOTE: solved because of blink.cmp config
--[[
vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = '*',
    callback = function()
        if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n')
            or (vim.v.event.old_mode == 'i' and vim.v.event.new_mode == 'n'))
            and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require('luasnip').session.jump_active
        then
            require('luasnip').unlink_current()
        end
    end
})
--]]

vim.keymap.set('n', '<Leader>z', function ()
    if require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
    then
        require('luasnip').unlink_current()
    end
end, { noremap = true, desc = "clear snippet jump" })

vim.keymap.set({ 'i', 'n' }, '<C-Tab>', function ()
    if require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
    then
        require('luasnip').unlink_current()
    end
end)

