local M = {}

---@alias ClientSelections table<string, LspSelection>

---@class LspSelection
---@field display string
---@field callback function

---@class LspSelectionManager
---@field items string[]
---@field callbacks table<string, function>
---@field displays table<string, string>

M.setup = function()
    ---@type table<string, ClientSelections>
    M.lsp_selections = {}
end

---@param client_name string
---@param id string
---@param display string
---@param callback function
M.add_lsp_selection = function(client_name, id, display, callback)
    M.lsp_selections[client_name] = M.lsp_selections[client_name] or {}
    local client_selections = M.lsp_selections[client_name]
    client_selections[id] = {
        display = client_name .. ': ' .. display,
        callback = callback,
    }
end

---@param client_name string
M.remove_client_selections = function(client_name)
    M.lsp_selections[client_name] = nil
end

---@return LspSelectionManager
M.get_lsp_selections = function()
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

return M
