local event_presets = require("core.config").event_presets

return {
    -- https://github.com/copilotlsp-nvim/copilot-lsp
    -- Copilot LSP: Copilot LSP Configuration for Neovim
    {
        "copilotlsp-nvim/copilot-lsp",
        event = event_presets.load_ai,
        init = function()
            vim.g.copilot_nes_debounce = 500
        end,
        config = function()
            vim.lsp.enable("copilot_ls")
        end,
        keys = {
            {
                "<Tab>",
                function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    local state = vim.b[bufnr].nes_state
                    if state then
                        -- Try to jump to the start of the suggestion edit.
                        -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
                        local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
                            or (
                                require("copilot-lsp.nes").apply_pending_nes()
                                and require("copilot-lsp.nes").walk_cursor_end_edit()
                            )
                        return nil
                    else
                        -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
                        return "<C-i>"
                    end
                end,
                desc = "Accept Copilot NES suggestion",
                expr = true,
            },
        },
    },

    -- https://github.com/zbirenbaum/copilot.lua
    -- copilot.lua: This plugin is the pure lua replacement for github/copilot.vim.
    {
        "zbirenbaum/copilot.lua",
        dependencies = { "copilotlsp-nvim/copilot-lsp" }, -- (optional) for NES functionality
        event = event_presets.load_ai,
        cmd = "Copilot",
        config = function()
            local enable_nes = require("core.config").copilot.enable_nes
            local enable_suggestions = require("core.config").copilot.enable_immediate_suggestions
            require("copilot").setup({
                nes = {
                    enabled = enable_nes,
                    keymap = {
                        accept_and_goto = false,
                        accept = false,
                        dismiss = false,
                    },
                },
                suggestion = { enabled = enable_suggestions },
                panel = { enabled = false },
                filetypes = {
                    markdown = false,
                    help = false,
                    text = false,
                    conf = false,
                },
                disable_limit_reached_message = true, -- Set to `true` to suppress completion limit reached popup
            })

            if enable_nes then
                local nes_api = require("copilot.nes.api")
                local function accept_suggestion(goto_end)
                    local result = nes_api.nes_apply_pending_nes()

                    if goto_end and result then
                        nes_api.nes_walk_cursor_end_edit()
                    end

                    return result
                end

                vim.keymap.set("n", "<Leader>zz", function()
                    return accept_suggestion(true)
                end, { desc = "[AI completion] accept suggestion", noremap = true })
                vim.keymap.set({ "n", "i" }, "<C-p>", function()
                    return accept_suggestion(true)
                end, { desc = "[AI completion] accept suggestion", noremap = true })
                vim.keymap.set("n", "<Leader>zx", function()
                    return nes_api.nes_clear()
                end, { desc = "[AI completion] dismiss suggestion", noremap = true })
            end
        end,
        keys = {
            { "<Leader>ad", "<Cmd>Copilot disable<CR>", desc = "Disable Copilot", noremap = true },
            { "<Leader>ae", "<Cmd>Copilot enable<CR>", desc = "Enable Copilot", noremap = true },
        },
    },

    -- https://github.com/fang2hou/blink-copilot
    -- blink-copilot: Configurable GitHub Copilot blink.cmp source
    {
        "fang2hou/blink-copilot",
        dependencies = { "zbirenbaum/copilot.lua" },
        event = event_presets.load_ai,
        opts = {
            auto_refresh = {
                backward = true,
                forward = true,
            },
        },
    },

    -- https://github.com/AndreM222/copilot-lualine
    -- copilot-lualine: Component for lualine with the purpose of recieving and previewing status of copilot.lua
    {
        "AndreM222/copilot-lualine",
        dependencies = {
            "nvim-lualine/lualine.nvim",
        },
        event = event_presets.load_ai,
    },

    -- https://github.com/ravitemer/mcphub.nvim
    -- MCP HUB: MCP Hub is a MCP client for neovim that seamlessly integrates MCP (Model Context Protocol) servers
    -- into your editing workflow. It provides an intuitive interface for managing, testing, and
    -- using MCP servers with your favorite chat plugins.
    {
        "ravitemer/mcphub.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the neovim plugin
        opts = {
            use_bundled_binary = true, -- Use local `mcp-hub` binary
        },
        event = event_presets.start_edit,
    },

    -- https://github.com/Davidyz/VectorCode
    -- VectorCode: VectorCode is a code repository indexing tool. It helps you build better prompt for
    -- your coding LLMs by indexing and providing information about the code repository you're working on.
    {
        "Davidyz/VectorCode",
        version = "*",
        build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
        -- build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
        dependencies = { "nvim-lua/plenary.nvim" },
        event = event_presets.load_ai,
    },

    -- https://github.com/ravitemer/codecompanion-history.nvim
    -- CodeCompanion History Extension: A history management extension for codecompanion.nvim that
    -- enables saving, browsing and restoring chat sessions.
    {
        "ravitemer/codecompanion-history.nvim",
        dependencies = {
            "Davidyz/VectorCode",
            "folke/snacks.nvim",
        },
        event = event_presets.load_ai,
    },
}
