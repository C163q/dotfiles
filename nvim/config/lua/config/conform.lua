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
