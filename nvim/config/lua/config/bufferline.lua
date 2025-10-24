-- Go to Next BufferLine when press ctrl+N
-- Go to Prev BufferLine when press ctrl+B
vim.keymap.set("", "<C-h>", function()
    vim.cmd("BufferLineCyclePrev")
end, {
    noremap = true,
    desc = "BufferLineCyclePrev",
})

vim.keymap.set("", "<C-l>", function()
    vim.cmd("BufferLineCycleNext")
end, {
    noremap = true,
    desc = "BufferLineCycleNext",
})

vim.keymap.set("i", "<C-h>", "<Esc>:BufferLineCyclePrev<CR>i", {
    noremap = true,
    desc = "BufferLineCyclePrev",
})

vim.keymap.set("i", "<C-l>", "<Esc>:BufferLineCycleNext<CR>i", {
    noremap = true,
    desc = "BufferLineCycleNext",
})

-- BufferLine Pick when press <Leader>B
-- BufferLine Pick Close when press <Leader>N
vim.keymap.set("", "<Leader>bb", function()
    vim.cmd("BufferLinePick")
end, {
    noremap = true,
    desc = "Pick tab at BufferLine",
})

vim.keymap.set("", "<Leader>bc", function()
    vim.cmd("BufferLinePickClose")
end, {
    noremap = true,
    desc = "Close tab at BufferLine",
})

-- BufferLine Pin current file when press <Leader>P
vim.keymap.set("", "<Leader>bp", function()
    vim.cmd("BufferLineTogglePin")
end, {
    noremap = true,
    desc = "Pin current window at BufferLine",
})

-- Close current tab when press <Leader>C
vim.keymap.set("", "<Leader>c", function()
    local buffer_id = vim.fn.bufnr()
    if buffer_id then
        vim.cmd("BufferLineCyclePrev")
        vim.cmd("bdelete " .. buffer_id)
    end
end, {
    noremap = true,
    desc = "Close current window",
})

-- BufferLineMovePrev
vim.keymap.set("", "<Leader>[", "<Cmd>BufferLineMovePrev<CR>", {
    noremap = true,
    desc = "BufferLine move prev",
})

-- BufferLineMovePrev
vim.keymap.set("", "<C-J>", "<Cmd>BufferLineMovePrev<CR>", {
    noremap = true,
    desc = "BufferLine move prev",
})

-- BufferLineMoveNext
vim.keymap.set("", "<Leader>]", "<Cmd>BufferLineMoveNext<CR>", {
    noremap = true,
    desc = "BufferLine move next",
})

-- BufferLineMoveNext
vim.keymap.set("", "<C-K>", "<Cmd>BufferLineMoveNext<CR>", {
    noremap = true,
    desc = "BufferLine move next",
})

--[[
local bufferline = require("bufferline")
-- Test
vim.keymap.set("", "<Leader>v", function()
    -- bufferline.exec(1, function(buf, visible_buffers)
    --     vim.cmd('bdelete'..buf.id)
    -- end)
end, {
    noremap = true,
    desc = "Test",
})
--]]
