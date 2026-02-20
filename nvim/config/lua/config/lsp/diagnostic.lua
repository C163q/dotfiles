local lsp_core = require("config.lsp.core")
local user_config = require("core.config")

-- Show line diagnostics automatically in hover window
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus=false, focusable = false })]]

vim.api.nvim_create_augroup("ConfigDiagnosticFloatWindow", { clear = true })
local float_window_action = {
    group = "ConfigDiagnosticFloatWindow",
    pattern = "*",
    callback = function()
        vim.diagnostic.open_float({
            focus = false,
            focusable = false,
            border = "rounded",
            close_events = { "CursorMoved", "CursorMovedI", "CursorMovedC", "BufLeave" },
            severity_sort = true,
        })
    end,
}
-- CursorHoldI will show diagnostics on Insert mode
local float_window_action_autocmd_id = vim.api.nvim_create_autocmd({
    "CursorHold", --[['CursorHoldI'--]]
}, float_window_action)

vim.keymap.set(
    "n",
    "<Leader>ld",
    (function()
        ---@type integer|nil
        local d_autocmd_id = float_window_action_autocmd_id
        return function()
            if d_autocmd_id == nil then
                d_autocmd_id = vim.api.nvim_create_autocmd({ "CursorHold" }, float_window_action)
            else
                local tmp_id = d_autocmd_id
                d_autocmd_id = nil -- Handle unknown bug of missing d_autocmd_id
                vim.api.nvim_del_autocmd(tmp_id)
            end
        end
    end)(),
    { noremap = true, desc = "Toggle auto Float Window of Diagnostics" }
)

-- config: vim.lsp.buf.hover
vim.api.nvim_create_augroup("ConfigAutoHoverFloatWindow", { clear = true })
local lsp_hover_window_action = {
    group = "ConfigAutoHoverFloatWindow",
    pattern = "*",
    callback = function()
        vim.lsp.buf.hover({
            focusable = true,
            focus = false,
            close_events = { "CursorMoved", "CursorMovedI", "CursorMovedC" },
            border = "rounded",
            silent = true,
        })
    end,
}

vim.keymap.set(
    "n",
    "<Leader>lo",
    (function()
        local auto_hover_window_id = nil
        local set_keymap_func = function()
            vim.keymap.set("n", "<Leader>;", function()
                vim.lsp.buf.hover({
                    focusable = true,
                    focus = true,
                    close_events = { "CursorMoved", "CursorMovedI", "CursorMovedC" },
                    border = "rounded",
                    silent = false,
                })
            end, { noremap = true, desc = "Show LSP hover help" })
            vim.keymap.set(
                "n",
                "<Leader>:",
                "<Leader>;<Leader>;",
                { remap = true, desc = "Show LSP hover help and ENTER" }
            )
        end
        local del_keymap_func = function()
            vim.keymap.del("n", "<Leader>;", {})
            vim.keymap.del("n", "<Leader>:", {})
        end

        set_keymap_func()

        return function()
            if auto_hover_window_id == nil then
                auto_hover_window_id = vim.api.nvim_create_autocmd({ "CursorHold" }, lsp_hover_window_action)
                del_keymap_func()
            else
                local tmp_id = auto_hover_window_id
                auto_hover_window_id = nil -- Handle unknown bug of missing d_autocmd_id
                vim.api.nvim_del_autocmd(tmp_id)
                set_keymap_func()
            end
        end
    end)(),
    { noremap = true, desc = "Toggle LSP hover help" }
)

-- config: float text of diagnostics
vim.keymap.set(
    "n",
    "<Leader>lf",
    (function()
        local diag_status = true
        return function()
            if diag_status then
                diag_status = false
                vim.diagnostic.config({ virtual_text = true })
            else
                diag_status = true
                vim.diagnostic.config({ virtual_text = false })
            end
        end
    end)(),
    { noremap = true, desc = "Toggle Float Text of Diagnostics" }
)

-- config: keymap of signature_help
vim.keymap.set("i", "<C-e>", function()
    vim.lsp.buf.signature_help({
        focusable = true,
        focus = true,
        border = "rounded",
    })
end, { noremap = true, desc = "Signature help" })

vim.keymap.set("n", "<C-e>", function()
    vim.lsp.buf.signature_help({
        focusable = true,
        focus = true,
        border = "rounded",
    })
end, { noremap = true, desc = "Signature help" })

local function quickfix()
    vim.lsp.buf.code_action({
        filter = function(action)
            return action.isPreferred
        end,
        apply = true,
    })
end

vim.keymap.set("n", "<Leader>lI", quickfix, { noremap = true, silent = false, desc = "Quickfix automatically" })
vim.keymap.set("n", "<Leader>lq", function()
    vim.lsp.buf.code_action({
        apply = false,
    })
end, { noremap = true, silent = false, desc = "Quickfix with choice" })

-- LSP dynamic configurations
-- This will show a selection menu of available LSP configurations
vim.keymap.set("n", "<Leader>L", function()
    local selections = lsp_core.get_lsp_selections()
    if #selections.items == 0 then
        vim.notify("No LSP configurations available", vim.log.levels.INFO)
        return
    end
    vim.ui.select(selections.items, {
        prompt = "LSP Configurations:",
        format_item = function(item)
            return selections.displays[item]
        end,
    }, function(selected)
        if selected == nil then
            return
        end
        local callback = selections.callbacks[selected]
        if callback ~= nil then
            callback()
        end
    end)
end, { noremap = true, desc = "LSP configs" })

local icons_diagnostic = require("core.config").icon.diagnostics
-- Sets icons and styling for diagnostics
vim.diagnostic.config({
    virtual_text = { -- true
        -- prefix = icons_diagnostic.virtual_text_prefix,
    },
    signs = { -- true
        active = true,
        text = {
            [vim.diagnostic.severity.ERROR] = icons_diagnostic.error,
            [vim.diagnostic.severity.WARN] = icons_diagnostic.warn,
            [vim.diagnostic.severity.INFO] = icons_diagnostic.info,
            [vim.diagnostic.severity.HINT] = icons_diagnostic.hint,
        },
    },
    float = { -- true
        source = true,
        border = "border",
    },
    update_in_insert = false,
    severity_sort = true,
})

-- ###########################################
-- #    CODE ACTION SIGN DEFINITION BEGIN    #
-- ###########################################
-- lightbulb when code action is available
-- inspired by [lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim)
local uv = vim.uv
local code_action = {
    namespace = vim.api.nvim_create_namespace("ConfigCodeActionSign"),
    hl = "lightbulb",
    name = "ConfigLightbulb",
    group = "ConfigCodeActionSign",
    timer = nil,
    inrender_id = 0,
    inrender_buf = nil,
}

code_action.timer = uv.new_timer()
if code_action.timer == nil then
    vim.notify("Failed to create timer", vim.log.levels.WARN)
    return
end

vim.api.nvim_set_hl(code_action.namespace, code_action.hl, {
    fg = user_config.code_action.hl,
})

--[[
if user_config.code_action.text then
    vim.fn.sign_define(code_action.name, { text = user_config.code_action.text })
end
--]]

local function severity_vim_to_lsp(severity)
    if type(severity) == "string" then
        severity = vim.diagnostic.severity[severity]
    end
    return severity
end

--- @param diagnostic vim.Diagnostic
--- @return lsp.DiagnosticTag[]?
local function tags_vim_to_lsp(diagnostic)
    if not diagnostic._tags then
        return
    end

    local tags = {} --- @type lsp.DiagnosticTag[]
    if diagnostic._tags.unnecessary then
        tags[#tags + 1] = vim.lsp.protocol.DiagnosticTag.Unnecessary
    end
    if diagnostic._tags.deprecated then
        tags[#tags + 1] = vim.lsp.protocol.DiagnosticTag.Deprecated
    end
    return tags
end

---@diagnostic disable-next-line: unused-function
local function diagnostic_vim_to_lsp(diagnostics)
    ---@param diagnostic vim.Diagnostic
    ---@return lsp.Diagnostic
    return vim.tbl_map(function(diagnostic)
        local user_data = diagnostic.user_data or {}
        if user_data.lsp and not vim.tbl_isempty(user_data.lsp) and user_data.lsp.range then
            return user_data.lsp
        end
        return {
            range = {
                start = {
                    line = diagnostic.lnum + 1,
                    character = diagnostic.col,
                },
                ["end"] = {
                    line = diagnostic.end_lnum + 1,
                    character = diagnostic.end_col,
                },
            },
            severity = severity_vim_to_lsp(diagnostic.severity),
            message = diagnostic.message,
            source = diagnostic.source,
            code = diagnostic.code,
            tags = tags_vim_to_lsp(diagnostic),
        }
    end, diagnostics)
end

local function update_lightbulb(bufnr, row)
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    pcall(vim.api.nvim_buf_del_extmark, bufnr, code_action.namespace, code_action.inrender_id)

    if not row then
        return
    end

    local id = vim.api.nvim_buf_set_extmark(bufnr, code_action.namespace, row, -1, {
        virt_text = { { "  " .. user_config.code_action.text, code_action.hl } },
        virt_text_pos = "overlay",
        hl_mode = "combine",
    })

    code_action.inrender_id = id
    code_action.inrender_buf = bufnr
end

---@diagnostic disable-next-line: unused-function
local function render_lightbulb()
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local bufnr = vim.api.nvim_get_current_buf()
    local lsp = vim.lsp
    local params = lsp.util.make_range_params(0, "utf-8")
    params.context = {
        diagnostics = diagnostic_vim_to_lsp(vim.diagnostic.get(bufnr, { lnum = row })),
    }

    lsp.buf_request_all(bufnr, "textDocument/codeAction", params, function(results, ctx, config)
        if vim.api.nvim_get_current_buf() ~= bufnr then
            return
        end

        local result = results and results[ctx.client_id] and results[ctx.client_id].result

        if result and #result > 0 then
            update_lightbulb(bufnr, row)
        -- else
        --     update_lightbulb(bufnr, nil)
        end
    end)
end
-- ###########################################
-- #     CODE ACTION SIGN DEFINITION END     #
-- ###########################################

-- Lsp attach config
vim.api.nvim_create_augroup("ConfigLspDiagnosticConfigs", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = "ConfigLspDiagnosticConfigs",
    callback = function(event)
        -- obtain LSP client
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- [basic keymaps]

        --[[ Use picker for better UI
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
            buffer = event.buf,
            noremap = true,
            desc = "Go to definition",
        })

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
            buffer = event.buf,
            noremap = true,
            desc = "Go to declaration",
        })
        --]]

        vim.keymap.set("n", "gF", function()
            local org_path = vim.api.nvim_buf_get_name(0)

            -- Go to definition:
            vim.api.nvim_command("normal gd")

            -- Wait LSP server response
            vim.wait(100, function()
                return true
            end)

            local new_path = vim.api.nvim_buf_get_name(0)
            if not (org_path == new_path) then
                -- Create a new tab for the original file
                vim.api.nvim_command("0tabnew %")

                -- Restore the cursor position
                vim.api.nvim_command("b " .. org_path)
                vim.api.nvim_command('normal! `"')

                -- Switch to the original tab
                vim.api.nvim_command("normal! gt")
            end
        end, {
            noremap = true,
            desc = "Go to definition in a new TAB",
        })

        -- [diagnostics]
        vim.diagnostic.config({
            virtual_text = true,
        })

        -- Toggle inlay hint
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.keymap.set("n", "<Leader>lh", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, { buffer = event.buf, desc = "Toggle Inlay Hints" })
        end

        --[[    use snacks.nvim -> word
        -- highlight words under cursor
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('ConfigLSPDocumentHighlightToggle', { clear = false })
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
        vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("ConfigLSPDetachCleanUp", { clear = true }),
            ---@diagnostic disable-next-line: unused-local
            callback = function(detach_event)
                -- vim.lsp.buf.clear_references()
                -- vim.api.nvim_clear_autocmds({ group = 'LSPDocumentHighlightToggle', buffer = detach_event.buf })
            end,
        })

        -- vim.notify(client.name, 2)
        --[[
        if client and client.name == 'basedpyright' then
            vim.keymap.set('n', '<Leader>lp',function()
                    if _G.MyCustomSettings.basedpyright_loose_check then
                        _G.MyCustomSettings.basedpyright_loose_check = false
                    else
                        _G.MyCustomSettings.basedpyright_loose_check = true
                    end
                    vim.lsp.buf.clear_references()
            end, { buffer = event.buf, noremap = true, desc = "Toggle basedpyright Type Check" })
        end
        --]]

        vim.api.nvim_create_augroup(code_action.group, { clear = true })
        local code_action_autocmd_opt = {
            group = code_action.group,
            buffer = event.buf,
            callback = function(args)
                local buf = args.buf
                if code_action.timer == nil then
                    return
                end
                code_action.timer:stop()
                update_lightbulb(code_action.inrender_buf, nil)
                code_action.timer:start(
                    user_config.code_action.interval,
                    0,
                    vim.schedule_wrap(function()
                        code_action.timer:stop()
                        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_current_buf() == buf then
                            render_lightbulb()
                        end
                    end)
                )
            end,
        }

        vim.keymap.set("n", "<Leader>'", (function ()
            local la_autocmd_id = nil
            if user_config.code_action.enable then
                la_autocmd_id = vim.api.nvim_create_autocmd("CursorMoved", code_action_autocmd_opt)
            end
            return function()
                if la_autocmd_id == nil then
                    la_autocmd_id = vim.api.nvim_create_autocmd("CursorMoved", code_action_autocmd_opt)
                    vim.notify("Code Action Lightbulb Enabled", vim.log.levels.INFO)
                else
                    local tmp_id = la_autocmd_id
                    la_autocmd_id = nil
                    update_lightbulb(code_action.inrender_buf, nil)
                    vim.api.nvim_del_autocmd(tmp_id)
                    vim.notify("Code Action Lightbulb Disabled", vim.log.levels.INFO)
                end
            end
        end)(),
        { noremap = true, desc = "Toggle Code Action Marker" })
    end,
})
