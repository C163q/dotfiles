-- stylua: ignore start
local user_config = require("core.config")
-- stylua: ignore end

return {
    -- https://github.com/akinsho/bufferline.nvim
    -- bufferline.nvim: A snazzy buffer line (with tabpage integration) for Neovim built using lua.
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
        opts = {
            options = {
                close_command = "bdelete! %d",
                hover = {
                    enabled = true,
                    delay = 100,
                    reveal = { "close" },
                },
                indicator = {
                    style = "underline",
                    icon = "_",
                },
                pick = {
                    alphabet = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
                },
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local bufferline_icon = require("core.config").icon.bufferline
                    local s = ""
                    for e, n in pairs(diagnostics_dict) do
                        local sym = e == "error" and bufferline_icon.error
                            or (e == "warning" and bufferline_icon.warn or bufferline_icon.info)
                        s = s .. n .. sym
                    end
                    return s
                end,
                -- 左侧让出 nvim-tree 的位置
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "center",
                    },
                    {
                        filetype = "codecompanion",
                        text = "AI Chat",
                        highlight = "Directory",
                        text_align = "center",
                    },
                },
                custom_filter = function(buf_number, buf_numbers)
                    -- filter out filetypes you don't want to see
                    local filetypes = user_config.bufferline_filter.filetypes
                    local buftypes = user_config.bufferline_filter.buftypes

                    if
                        vim.tbl_contains(buftypes, vim.bo[buf_number].buftype)
                        or vim.tbl_contains(filetypes, vim.bo[buf_number].filetype)
                    then
                        return false
                    end
                    return true
                end,
            },
            highlights = require("catppuccin.special.bufferline").get_theme(),
        },
        keys = {
            -- Go to Next BufferLine when press ctrl+N
            -- Go to Prev BufferLine when press ctrl+B
            {
                "<C-h>",
                function()
                    vim.cmd("BufferLineCyclePrev")
                end,
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "BufferLineCyclePrev",
            },
            {
                "<C-l>",
                function()
                    vim.cmd("BufferLineCycleNext")
                end,
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "BufferLineCycleNext",
            },
            {

                "<C-h>",
                "<Esc>:BufferLineCyclePrev<CR>i",
                mode = "i",
                noremap = true,
                desc = "BufferLineCyclePrev",
            },
            {
                "<C-l>",
                "<Esc>:BufferLineCycleNext<CR>i",
                mode = "i",
                noremap = true,
                desc = "BufferLineCycleNext",
            },
            -- BufferLine Pick when press <Leader>B
            -- BufferLine Pick Close when press <Leader>N
            {
                "<Leader>bb",
                function()
                    vim.cmd("BufferLinePick")
                end,
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "Pick tab at BufferLine",
            },
            {
                "<Leader>bc",
                function()
                    vim.cmd("BufferLinePickClose")
                end,
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "Close tab at BufferLine",
            },
            {
                -- BufferLine Pin current file when press <Leader>P
                "<Leader>bp",
                function()
                    vim.cmd("BufferLineTogglePin")
                end,
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "Pin current window at BufferLine",
            },
            {
                -- Close current tab when press <Leader>C
                "<Leader>c",
                function()
                    local buffer_id = vim.fn.bufnr()
                    if buffer_id then
                        vim.cmd("BufferLineCyclePrev")
                        vim.cmd("bdelete " .. buffer_id)
                    end
                end,
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "Close current window",
            },
            {
                -- BufferLineMovePrev
                "<Leader>[",
                "<Cmd>BufferLineMovePrev<CR>",
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "BufferLine move prev",
            },
            {
                -- BufferLineMovePrev
                "<C-J>",
                "<Cmd>BufferLineMovePrev<CR>",
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "BufferLine move prev",
            },
            {
                -- BufferLineMoveNext
                "<Leader>]",
                "<Cmd>BufferLineMoveNext<CR>",
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "BufferLine move next",
            },
            {
                -- BufferLineMoveNext
                "<C-K>",
                "<Cmd>BufferLineMoveNext<CR>",
                mode = { "n", "v", "o" },
                noremap = true,
                desc = "BufferLine move next",
            },
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
        },
    },
}
