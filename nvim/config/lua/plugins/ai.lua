local event_presets = require("core.config").event_presets

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
        branch = "pull/279/merge",
        -- `CodeCompanion` has updated to v19, but the lastest `mcphub.nvim` has not merged the PR
        -- that supports `CodeCompanion` v19 yet.
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
}
