local api = vim.api

-- Open terminal (not default) when press <Leader>t
api.nvim_set_keymap(
    '',
    '<Leader>t',
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


