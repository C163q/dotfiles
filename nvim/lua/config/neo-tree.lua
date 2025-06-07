local api = vim.api

-- PLUGIN neo-tree config
vim.keymap.set(
    '',
    '<C-Q>',
    function()
        if (vim.bo.filetype == 'neo-tree') then
            vim.cmd("Neotree toggle=true")
        else
            vim.cmd("Neotree")
        end
    end,
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


