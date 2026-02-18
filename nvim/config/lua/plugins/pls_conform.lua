local event_presets = require("core.config").event_presets

return {
    -- https://github.com/stevearc/conform.nvim
    -- conform.nvim: Lightweight yet powerful formatter plugin for Neovim
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    -- You can customize some of the format options for the filetype (:help conform.format)
                    lua = { "stylua" },
                    -- Conform will run multiple formatters sequentially
                    python = { "isort", "black" },
                    rust = { "rustfmt", lsp_format = "fallback" },
                    cpp = { "clang-format" },
                },
            })

            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

            local conform = require("conform")

            vim.api.nvim_create_user_command("FormatSelected", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        ["start"] = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end
                conform.format({ async = true, lsp_fallback = true, range = range })
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, true, true), "n", true)
            end, { range = true })

            vim.keymap.set("v", "<Leader>fa", function()
                vim.cmd("FormatSelected")
            end, { noremap = true, desc = "Format selected line" })

            vim.keymap.set("", "<Leader>fA", function()
                conform.format({ async = true, bufnr = vim.api.nvim_get_current_buf() })
            end, { noremap = true, desc = "Format current file" })

            vim.keymap.set("", "<Leader>f=", function()
                conform.format({ async = false, bufnr = vim.api.nvim_get_current_buf() })
                vim.cmd("write")
            end, { noremap = true, desc = "Format current file and save" })
        end,
        event = event_presets.start_edit,
        version = "*",
    },

    -- https://github.com/zapling/mason-conform.nvim
    -- mason-conform.nvim: Automatically install formatters registered with conform.nvim via Mason.
    {
        "zapling/mason-conform.nvim",
        event = event_presets.start_edit,
        dependencies = {
            "mason-org/mason.nvim",
            "stevearc/conform.nvim",
        },
    },
}
