-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus=false, focusable = false })]]

vim.api.nvim_create_augroup("DiagnosticFloatWindow", { clear = true })
local float_window_action = {
    group = "DiagnosticFloatWindow",
    pattern = '*',
    callback = function()
        vim.diagnostic.open_float(nil, { focus=false, focusable = false, border = "rounded" })
    end,
}
-- CursorHoldI will show diagnostics on Insert mode
local autocmd_id = vim.api.nvim_create_autocmd({ 'CursorHold', --[['CursorHoldI'--]] }, float_window_action)

vim.keymap.set('n', '<Leader>ld', (function ()
    local d_autocmd_id = autocmd_id
    return function ()
        if d_autocmd_id == nil then
            d_autocmd_id = vim.api.nvim_create_autocmd({ 'CursorHold' }, float_window_action)
        else
            local tmp_id = d_autocmd_id
            d_autocmd_id = nil  -- Handle unknown bug of missing d_autocmd_id
            vim.api.nvim_del_autocmd(tmp_id)
        end
    end
end)(),
{ noremap = true, desc = 'Toggle auto Float Window of Diagnostics' })


-- config: vim.lsp.buf.hover
vim.api.nvim_create_augroup("AutoHoverFloatWindow", { clear = true })
local lsp_hover_window_action = {
    group = "AutoHoverFloatWindow",
    pattern = "*",
    callback = function ()
        vim.lsp.buf.hover({
            focusable = true,
            focus = false,
            close_events = { 'CursorMoved', 'CursorMovedI', 'CursorMovedC' },
            border = "rounded",
            silent = true,
        })
    end
}

vim.keymap.set('n', '<Leader>lo', (function ()
    local auto_hover_window_id = nil
    local set_keymap_func = function ()
        vim.keymap.set('n', '<Leader>;', function ()
            vim.lsp.buf.hover({
                focusable = true,
                focus = true,
                close_events = { 'CursorMoved', 'CursorMovedI', 'CursorMovedC' },
                border = "rounded",
                silent = false,
            })
        end,
        { noremap = true, desc = 'Show LSP hover help' })
        vim.keymap.set('n', '<Leader>:', '<Leader>;<Leader>;',
        { remap = true, desc = 'Show LSP hover help and ENTER' })
    end
    local del_keymap_func = function ()
        vim.keymap.del('n', '<Leader>;', {})
        vim.keymap.del('n', '<Leader>:', {})
    end

    set_keymap_func()

    return function ()
        if auto_hover_window_id == nil then
            auto_hover_window_id = vim.api.nvim_create_autocmd({ 'CursorHold' }, lsp_hover_window_action)
            del_keymap_func()
        else
            local tmp_id = auto_hover_window_id
            auto_hover_window_id = nil  -- Handle unknown bug of missing d_autocmd_id
            vim.api.nvim_del_autocmd(tmp_id)
            set_keymap_func()
        end
    end
end)(),
{ noremap = true, desc = 'Toggle LSP hover help' })


-- config: float text of diagnostics
vim.keymap.set('n', '<Leader>lf', (function ()
    local diag_status = true
    return function ()
        if diag_status then
            diag_status = false
            vim.diagnostic.config({ virtual_text = true })
        else
            diag_status = true
            vim.diagnostic.config({ virtual_text = false })
        end
    end
end)(),
{ noremap = true, desc = 'Toggle Float Text of Diagnostics' })

-- config: keymap of signature_help
vim.keymap.set('i', '<C-e>', function ()
    vim.lsp.buf.signature_help({
        focusable = true,
        focus = true,
        border = "rounded",
    })
end)

vim.keymap.set('n', '<C-e>', function ()
    vim.lsp.buf.signature_help({
        focusable = true,
        focus = true,
        border = "rounded",
    })
end)


-- Lsp attach config
vim.api.nvim_create_augroup('LspDiagnosticConfigs', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
    group = 'LspDiagnosticConfigs',
    callback = function (event)
        -- obtain LSP client
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- [basic keymaps]
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
            buffer = event.buf,
            noremap = true,
            desc = "Go to definition"
        })

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
            buffer = event.buf,
            noremap = true,
            desc = "Go to declaration"
        })

        vim.keymap.set('n', 'gF', function()
            local org_path = vim.api.nvim_buf_get_name(0)

            -- Go to definition:
            vim.api.nvim_command('normal gd')

            -- Wait LSP server response
            vim.wait(100, function() end)

            local new_path = vim.api.nvim_buf_get_name(0)
            if not (org_path == new_path) then
                -- Create a new tab for the original file
                vim.api.nvim_command('0tabnew %')

                -- Restore the cursor position
                vim.api.nvim_command('b ' .. org_path)
                vim.api.nvim_command('normal! `"')

                -- Switch to the original tab
                vim.api.nvim_command('normal! gt')
            end
        end,
        {
            noremap = true,
            desc = "Go to definition in a new TAB"
        })

        -- [diagnostics]
        vim.diagnostic.config({
          virtual_text = true
        })

        -- Toggle inlay hint
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.keymap.set('n', '<Leader>lh', function ()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end,
            { buffer = event.buf, desc = 'Toggle Inlay Hints' })
        end

        --[[    use snacks.nvim -> word
        -- highlight words under cursor
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('LSPDocumentHighlightToggle', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
        end
        --]]

        -- offloads upon detachment
        vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('LSPDetachCleanUp', { clear = true }),
            callback = function (detach_event)
                -- vim.lsp.buf.clear_references()
                -- vim.api.nvim_clear_autocmds({ group = 'LSPDocumentHighlightToggle', buffer = detach_event.buf })
            end
        })

        -- vim.notify(client.name, 2)
        --[[
        if client and client.name == 'basedpyright' then
            vim.keymap.set('n', '<Leader>lp',function()
                    if _G.MyCustomSettings.basedpyrightTypeCheck then
                        _G.MyCustomSettings.basedpyrightTypeCheck = false
                    else
                        _G.MyCustomSettings.basedpyrightTypeCheck = true
                    end
                    vim.lsp.buf.clear_references()
            end, { buffer = event.buf, noremap = true, desc = "Toggle basedpyright Type Check" })
        end
        --]]

    end
})




