local api = vim.api

-- PLUGIN neo-tree config
api.nvim_set_keymap(
    '',
    '<C-Q>',
    ':Neotree<CR>',
    {
        noremap = true
    }
)

api.nvim_set_keymap(
    'i',
    '<C-Q>',
    '<Esc>:Neotree<CR>',
    {
        noremap = true
    }
)


