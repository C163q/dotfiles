vim.g.mapleader = ","

local api = vim.api


-- Undo when press Ctrl+Z
api.nvim_set_keymap(
    '',
    '<C-z>',
    '<Undo>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-z>',
    '<Esc><Undo>a',
    {
        noremap = true
    }
)


-- Use Ctrl+Shift+V instead of Ctrl+V
api.nvim_set_keymap(
    'n',
    '<C-S-v>',
    '<C-V>',
    {
        noremap = true
    }
)

-- Function to move the cursor by a specified number of lines
local function move_cursor_linewise(offset)
    if offset == 0 then
        return
    end
    if offset < 0 then
        offset = -offset
        vim.api.nvim_feedkeys(tostring(offset) .. "k", "n", false)
        return
    end
    vim.api.nvim_feedkeys(tostring(offset) .. "j", "n", false)
end

-- Go Up 5 lines when press Ctrl+Up
vim.keymap.set(
    '',
    '<C-Up>',
    '<Up><Up><Up><Up><Up>',
    {
        noremap = true
    }
)

vim.keymap.set(
    'i',
    '<C-Up>',
    '<Up><Up><Up><Up><Up>',
    {
        noremap = true
    }
)

-- Go Down 5 lines when press Ctrl+Down
vim.keymap.set(
    '',
    '<C-Down>',
    '<Down><Down><Down><Down><Down>',
    {
        noremap = true
    }
)

vim.keymap.set(
    'i',
    '<C-Down>',
    '<Down><Down><Down><Down><Down>',
    {
        noremap = true
    }
)

-- Change Windows when press shift+W
api.nvim_set_keymap(
    'n',
    '<S-W>',
    '<C-W>w',
    {
        noremap = true
    }
)

-- Go to the start of the LINE when press ctrl+shift+Left
api.nvim_set_keymap(
    '',
    '<C-S-Left>',
    '0',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-S-Left>',
    '<Esc>0i',
    {
        noremap = true
    }
)

-- Go to the end of the LINE when press ctrl+shift+Right
api.nvim_set_keymap(
    '',
    '<C-S-Right>',
    '$',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-S-Right>',
    '<Esc>$a',
    {
        noremap = true
    }
)

-- remap function of <S-Up> and <S-Down>
api.nvim_set_keymap(
    '',
    '<C-S-Up>',
    '<PageUp>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-S-Up>',
    '<PageUp>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    '',
    '<C-S-Down>',
    '<PageDown>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-S-Down>',
    '<PageDown>',
    {
        noremap = true
    }
)

-- <S-Up> and <S-Down> for scroll up or scroll down
api.nvim_set_keymap(
    '',
    '<S-Up>',
    '5<C-y>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    '',
    '<S-Down>',
    '5<C-e>',
    {
        noremap = true
    }
)

-- Move selected lines in VISUAL mode when press Shift+J or Shift+K
vim.keymap.set(
    'v',
    'J',
    ":m '>+1<CR>gv=gv",
    {
        noremap = true
    }
)

vim.keymap.set(
    'v',
    'K',
    ":m '<-2<CR>gv=gv",
    {
        noremap = true
    }
)

-- Same as yank in visual mode when press ctrl+C
api.nvim_set_keymap(
    'v',
    '<C-c>',
    'y',
    {
        noremap = true
    }
)

-- Same as yank a line in normal mode when press ctrl+C
api.nvim_set_keymap(
    'n',
    '<C-c>',
    '0Y$',
    {
        noremap = true
    }
)

-- Same as yank a line in insert mode when press ctrl+C
api.nvim_set_keymap(
    'i',
    '<C-c>',
    '<Esc>0Y$a',
    {
        noremap = true
    }
)

-- Same as cut in visual mode when press ctrl+X
api.nvim_set_keymap(
    'v',
    '<C-x>',
    'd',
    {
        noremap = true
    }
)

-- Same as cut a line in normal mode when press ctrl+X
api.nvim_set_keymap(
    'n',
    '<C-x>',
    'dd',
    {
        noremap = true
    }
)

-- Same as cut a line in insert mode when press ctrl+X
api.nvim_set_keymap(
    'i',
    '<C-x>',
    '<Esc>dda',
    {
        noremap = true
    }
)

-- Redo when press ctrl+R
api.nvim_set_keymap(
    '',
    '<C-r>',
    '<Cmd>redo<CR>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-r>',
    '<Esc><Cmd>redo<CR>i',
    {
        noremap = true
    }
)

-- exit terminal mode to normal mode when press <ESC>
api.nvim_set_keymap(
    't',
    '<Esc>',
    '<C-\\><C-n>',
    {
        noremap = true
    }
)

-- exit insert mode when press Alt+Space
vim.keymap.set(
    'i',
    '<M-Space>',
    '<Esc>',
    {
        noremap = true
    }
)

vim.keymap.set(
    "",
    '<Leader>vv',
    function ()
        vim.cmd('Inspect')
    end,
    { noremap = true, desc = "Inspect" }
)

vim.keymap.set(
    "",
    '<Leader>vp',
    "<Cmd>echo expand('%:p')<CR>",
    { noremap = true, desc = "Show full path" }
)

--[[
-- switch window with keypad Up Down Left Right
vim.keymap.set(
    'n',
    '<kUp>',
    '<C-w><Up>',
    {
        noremap = true
    }
)

vim.keymap.set(
    'n',
    '<kDown>',
    '<C-w><Down>',
    {
        noremap = true
    }
)

vim.keymap.set(
    'n',
    '<kLeft>',
    '<C-w><Left>',
    {
        noremap = true
    }
)

vim.keymap.set(
    'n',
    '<kRight>',
    '<C-w><Right>',
    {
        noremap = true
    }
)
--]]


