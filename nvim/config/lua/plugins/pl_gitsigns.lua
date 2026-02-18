local event_presets = require("core.config").event_presets

return {
    -- https://github.com/lewis6991/gitsigns.nvim
    -- gitsigns.nvim: Deep buffer integration for Git
    {
        "lewis6991/gitsigns.nvim",
        event = event_presets.start_edit,
        opts = {
            sign_priority = 100,
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    opts.noremap = true
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end)

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end)

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git stage current hunk" })
                map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git recover from staged hunk" })

                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }, { desc = "Git stage selected line" })
                end)

                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk(
                        { vim.fn.line("."), vim.fn.line("v") },
                        { desc = "Git recover selected line from staged" }
                    )
                end)

                map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git stage current file" })
                map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git recover from staged file" })
                map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git preview current hunk (float window)" })
                map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Git preview current hunk (inline)" })

                map("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end, { desc = "Git show blame of current line" })

                map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git show diff from staged" })

                map("n", "<leader>hD", function()
                    gitsigns.diffthis("~")
                end, { desc = "Git show diff from committed" })

                map("n", "<leader>hQ", function()
                    gitsigns.setqflist("all")
                end, { desc = "Show unstaged hunk list (all)" })
                map("n", "<leader>hq", gitsigns.setqflist, { desc = "Show unstaged hunk list (current file)" })

                -- Toggles
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle inline blame" })
                map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle highlight of changes (git)" })

                -- Text object
                map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk" })
            end,
        },
    },
}
