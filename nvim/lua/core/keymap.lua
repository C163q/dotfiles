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

-- Go Up 5 lines when press Ctrl+Up
api.nvim_set_keymap(
    '',
    '<C-Up>',
    '<Up><Up><Up><Up><Up>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-Up>',
    '<Up><Up><Up><Up><Up>',
    {
        noremap = true
    }
)

-- Go Down 5 lines when press Ctrl+Down
api.nvim_set_keymap(
    '',
    '<C-Down>',
    '<Down><Down><Down><Down><Down>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
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
    ':redo<CR>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-r>',
    '<Esc>:redo<CR>i',
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


