local api = vim.api

-- Go to Next BufferLine when press ctrl+N
-- Go to Prev BufferLine when press ctrl+B
api.nvim_set_keymap(
    '',
    '<C-h>',
    ':BufferLineCyclePrev<CR>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    '',
    '<C-l>',
    ':BufferLineCycleNext<CR>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-h>',
    '<Esc>:BufferLineCyclePrev<CR>i',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-l>',
    '<Esc>:BufferLineCycleNext<CR>i',
    {
        noremap = true
    }
)

-- BufferLine Pick when press <Leader>B
-- BufferLine Pick Close when press <Leader>N
api.nvim_set_keymap(
    '',
    '<Leader>b',
    ':BufferLinePick<CR>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    '',
    '<Leader>n',
    ':BufferLinePickClose<CR>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<Leader>b',
    '<Esc>:BufferLinePick<CR>i',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<Leader>n',
    '<Esc>:BufferLinePickClose<CR>i',
    {
        noremap = true
    }
)

-- BufferLine Pin current file when press <Leader>P
api.nvim_set_keymap(
    '',
    '<Leader>p',
    ':BufferLineTogglePin<CR>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<Leader>p',
    '<Esc>:BufferLineTogglePin<CR>i',
    {
        noremap = true
    }
)

-- Close current tab when press <Leader>C
api.nvim_set_keymap(
    '',
    '<Leader>c',
    ':bdelete<CR>',
    {
        noremap = true
    }
)





