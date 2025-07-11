local api = vim.api

-- Open terminal (not default) when press <Leader>t
api.nvim_set_keymap(
    '',
    '<Leader>tt',
    ':ToggleTerm<CR>',
    {
        noremap = true,
        desc = 'Open terminal (not default)'
    }
)

-- Open new terminal (not toggle) when press <Leader>\
api.nvim_set_keymap(
    '',
    '<Leader>\\',
    '<Cmd>exe v:count1 . "ToggleTerm"<CR>',
    {
        noremap = true,
        desc = 'Open terminal#n decided by number prefix'
    }
)

api.nvim_set_keymap(
    '',
    '<Leader>tS',
    '<Cmd>TermSelect<CR>',
    {
        noremap = true,
        desc = 'Select Terminal with input',
    }
)

api.nvim_set_keymap(
    '',
    '<Leader>ts',
    '<Cmd>exe v:count1 . "TermSelect"<CR>',
    {
        noremap = true,
        desc = 'Select #n terminal decided by number prefix',
    }
)

