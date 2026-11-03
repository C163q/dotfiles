local event_presets = require("core.config").event_presets
local sidekick_config = require("core.config").sidekick

return {
    -- https://github.com/monkoose/neocodeium
    -- Free AI completion plugin powered by windsurf (formerly codeium)
    {
        "monkoose/neocodeium",
        event = event_presets.load_ai,
        config = function()
            local neocodeium = require("neocodeium")
            local filetypes = { "markdown" }
            neocodeium.setup({
                -- function accepts one argument `bufnr`
                filter = function(bufnr)
                    if vim.tbl_contains(filetypes, vim.api.nvim_get_option_value("filetype", { buf = bufnr })) then
                        return false
                    end
                    return true
                end,
            })
            vim.keymap.set(
                "n",
                "<Leader>zz",
                neocodeium.accept,
                { desc = "[AI completion] accept suggestion", noremap = true }
            )
            vim.keymap.set(
                { "n", "i" },
                "<C-p>",
                neocodeium.accept,
                { desc = "[AI completion] accept suggestion", noremap = true }
            )
            vim.keymap.set(
                "n",
                "<Leader>zx",
                neocodeium.clear,
                { desc = "[AI completion] clear suggestion", noremap = true }
            )
            vim.keymap.set(
                "n",
                "<Leader>zc",
                neocodeium.accept_line,
                { desc = "[AI completion] accept line suggestion", noremap = true }
            )
        end,
        enabled = require("core.config").neocodeium.enable,
    },

    -- https://github.com/folke/sidekick.nvim
    -- sidekick.nvim: sidekick.nvim is your Neovim AI sidekick that integrates Copilot LSP's
    -- "Next Edit Suggestions" with a built-in terminal for any AI CLI. Review and apply diffs,
    -- chat with AI assistants, and streamline your coding, without leaving your editor.
    {
        "folke/sidekick.nvim",
        opts = {
            -- add any options here
            cli = {
                mux = {
                    backend = "zellij",
                    enabled = true,
                },
                win = {
                    -- keys = {
                    --     buffers       = { "<c-b>", "buffers"   , mode = "nt", desc = "open buffer picker" },
                    --     files         = { "<c-f>", "files"     , mode = "nt", desc = "open file picker" },
                    --     hide_n        = { "q"    , "hide"      , mode = "n" , desc = "hide the terminal window" },
                    --     hide_ctrl_q   = { "<c-q>", "hide"      , mode = "n" , desc = "hide the terminal window" },
                    --     hide_ctrl_dot = { "<c-.>", "hide"      , mode = "nt", desc = "hide the terminal window" },
                    --     hide_ctrl_z   = { "<c-z>", "blur"      , mode = "nt", desc = "go back to the previous window without hiding the terminal" },
                    --     prompt        = { "<c-p>", "prompt"    , mode = "t" , desc = "insert prompt or context" },
                    --     stopinsert    = { "<c-q>", "stopinsert", mode = "t" , desc = "enter normal mode" },
                    --     -- Navigate windows in terminal mode. Only active when:
                    --     -- * layout is not "float"
                    --     -- * there is another window in the direction
                    --     -- With the default layout of "right", only `<c-h>` will be mapped
                    --     nav_left      = { "<c-h>", "nav_left"  , expr = true, desc = "navigate to the left window" },
                    --     nav_down      = { "<c-j>", "nav_down"  , expr = true, desc = "navigate to the below window" },
                    --     nav_up        = { "<c-k>", "nav_up"    , expr = true, desc = "navigate to the above window" },
                    --     nav_right     = { "<c-l>", "nav_right" , expr = true, desc = "navigate to the right window" },
                    -- },
                },
            },
            nes = {
                ---@type boolean|fun(buf:integer):boolean?
                enabled = function(buf)
                    return vim.g.sidekick_nes ~= false
                        and vim.b.sidekick_nes ~= false
                        and sidekick_config.nes_enabled ~= false
                end,
            },
        },
        keys = {
            {
                sidekick_config.nes_apply_keymap,
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return sidekick_config.nes_apply_keymap -- fallback
                    end
                end,
                expr = true,
                desc = "[AI] Goto/Apply Next Edit Suggestion",
            },
            {
                "<c-.>",
                function()
                    require("sidekick.cli").focus()
                end,
                desc = "Sidekick Focus",
                mode = { "n", "t", "i", "x" },
            },
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "[AI] Sidekick Toggle CLI",
            },
            {
                "<leader>as",
                function()
                    require("sidekick.cli").select()
                end,
                -- Or to select only installed tools:
                -- require("sidekick.cli").select({ filter = { installed = true } })
                desc = "[AI] Select CLI",
            },
            {
                "<leader>ac",
                function()
                    require("sidekick.cli").close()
                end,
                desc = "[AI] Detach a CLI Session",
            },
            {
                "<leader>at",
                function()
                    require("sidekick.cli").send({ msg = "{this}" })
                end,
                mode = { "x", "n" },
                desc = "[AI] Send This",
            },
            {
                "<leader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}" })
                end,
                desc = "[AI] Send File",
            },
            {
                "<leader>av",
                function()
                    require("sidekick.cli").send({ msg = "{selection}" })
                end,
                mode = { "x" },
                desc = "[AI] Send Visual Selection",
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").prompt()
                end,
                mode = { "n", "x" },
                desc = "Sidekick Select Prompt",
            },
            {
                "<leader>aw",
                function()
                    require("sidekick.cli").toggle({ name = "codex", focus = true })
                end,
                desc = "Sidekick Toggle Codex",
            },
        },
    },
}
