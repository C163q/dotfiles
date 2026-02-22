local M = {}

-- ################################
-- #    LSP SELECTIONS MANAGER    #
-- ################################

---@alias ClientSelections table<string, LspSelection>

---@class LspSelection
---@field display string
---@field callback function

---@class LspSelectionManager
---@field items string[]
---@field callbacks table<string, function>
---@field displays table<string, string>

---@type table<string, ClientSelections>
M.lsp_selections = M.lsp_selections or {}

---@param client_name string
---@param id string
---@param display string
---@param callback function
function M.add_lsp_selection(client_name, id, display, callback)
    M.lsp_selections[client_name] = M.lsp_selections[client_name] or {}
    local client_selections = M.lsp_selections[client_name]
    client_selections[id] = {
        display = client_name .. ": " .. display,
        callback = callback,
    }
end

---@param client_name string
function M.remove_client_selections(client_name)
    M.lsp_selections[client_name] = nil
end

---@return LspSelectionManager
function M.get_lsp_selections()
    local selections = {}
    selections.items = {}
    selections.callbacks = {}
    selections.displays = {}
    local active_clients = vim.lsp.get_clients()

    for client_name, client_selections in pairs(M.lsp_selections) do
        if client_selections ~= nil then
            for _, client in ipairs(active_clients) do
                if client.name == client_name then
                    for item, selection in pairs(client_selections) do
                        table.insert(selections.items, item)
                        selections.callbacks[item] = selection.callback
                        selections.displays[item] = selection.display
                    end
                end
            end
        end
    end

    return selections
end

-- #############################
-- #   LSP CONFIGURE MANAGER   #
-- #############################

---@alias LspCallbacks { on_attach: function[] }
---@alias LspCallbackManager table<string, LspCallbacks>

---@type LspCallbackManager
M.lsp_callbacks = M.lsp_callbacks or {}

function M.init_lsp_configure()
    if M._lsp_configured then
        return
    end
    M._lsp_configured = true

    local function invoker(lsp_name)
        return function(client, bufnr)
            local callbacks = M.lsp_callbacks[lsp_name]
            if callbacks ~= nil and callbacks.on_attach ~= nil then
                for _, callback in ipairs(callbacks.on_attach) do
                    callback(client, bufnr)
                end
            end
        end
    end

    local lsp_list = require("core.config").lsp_list or {}
    local skip_enable = require("core.config").lsp_skip_enable or {}
    vim.lsp.config = vim.lsp.config or {}

    for _, lsp_name in ipairs(lsp_list) do
        M.lsp_callbacks[lsp_name] = M.lsp_callbacks[lsp_name] or {}

        if not vim.tbl_contains(skip_enable, lsp_name) then
            vim.lsp.config[lsp_name] = vim.lsp.config[lsp_name] or {}
            local config = vim.lsp.config[lsp_name]
            local on_attach = config.on_attach

            M.lsp_callbacks[lsp_name].on_attach = M.lsp_callbacks[lsp_name].on_attach or {}
            local attach_callbacks = M.lsp_callbacks[lsp_name].on_attach

            if type(on_attach) == "function" then
                table.insert(attach_callbacks, on_attach)
            elseif type(on_attach) == "table" then
                vim.tbl_extend('keep', attach_callbacks, on_attach)
            end
            vim.lsp.config(lsp_name, {
                on_attach = invoker(lsp_name),
            })
        end
    end

end

---@param lsp_name string
---@param callback function
---@return boolean
function M.add_on_attach(lsp_name, callback)
    M.init_lsp_configure()

    local config = vim.lsp.config[lsp_name]

    if config == nil or type(config.on_attach) ~= "function" then
        return false
    end

    if type(M.lsp_callbacks[lsp_name].on_attach) ~= "table" then
        return false
    end

    local attach_callbacks = M.lsp_callbacks[lsp_name].on_attach
    attach_callbacks[#attach_callbacks + 1] = callback
    return true
end

-- ###################
-- #    LSP UTILS    #
-- ###################

---@param client vim.lsp.Client
---@param clear boolean
M.client_stop_helper = function(client, clear)
    if client == nil then
        return
    end
    if clear then
        M.remove_client_selections(client.name)
    end
    client:stop()
    vim.lsp.buf.clear_references()
end

--- For `codesettings` plugin: get local settings for the given LSP name,
--- if any local config files were found, empty table otherwise.
---@param lsp_name string
---@return table
M.get_local_settings = function(lsp_name)
    if lsp_name == nil or lsp_name == "core" then
        return {}
    end
    local success, lsp = pcall(require, "config.lsp" .. lsp_name)
    if success and type(lsp.get_local_settings) == "function" then
        return lsp.get_local_settings()
    else
        return vim.lsp.config[lsp_name] or {}
    end
end

return M
