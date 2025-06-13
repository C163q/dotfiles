
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

        -- Show line diagnostics automatically in hover window
        vim.o.updatetime = 250
        -- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus=false, focusable = false })]]

        vim.api.nvim_create_augroup("DiagnosticFloatWindow", { clear = true })
        local float_window_action = {
            group = "DiagnosticFloatWindow",
            pattern = '*',
            callback = function()
                vim.diagnostic.open_float(nil, { focus=false, focusable = false })
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
        { buffer = event.buf, noremap = true, desc = 'Toggle auto Float Window of Diagnostics' })

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
        { buffer = event.buf, noremap = true, desc = 'Toggle Float Text of Diagnostics' })

        -- Toggle inlay hint
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.keymap.set('n', '<Leader>lh', function ()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end,
            { buffer = event.buf, desc = 'Toggle Inlay Hints' })
        end

        -- highlight words under cursor
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('LSPDocumentHighlightToggle', { clear = true })
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

    end
})




