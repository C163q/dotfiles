local M = {}

---@param choice boolean
---@param overrides table | nil
---@param original table | nil
local function make_config(choice, overrides, original)
    local overrides_tbl = overrides or {}
    local original_tbl = original or {}
    if choice then
        vim.lsp.config("basedpyright", {
            settings = {
                basedpyright = {
                    analysis = {
                        diagnosticSeverityOverrides = overrides_tbl,
                    },
                },
            },
        })
    else
        vim.lsp.config("basedpyright", {
            settings = {
                basedpyright = {
                    analysis = {
                        diagnosticSeverityOverrides = original_tbl,
                    },
                },
            },
        })
    end
end

--- Configure basedpyright LSP server
---@param choice boolean
function M.disable_annotation_missing_check(choice)
    make_config(choice, {
        reportUnknownParameterType = "none",
        reportUnknownArgumentType = "none",
        reportUnknownLambdaType = "none",
        reportUnknownVariableType = "none",
        reportUnknownMemberType = "none",
        reportMissingParameterType = "none",
        reportMissingTypeArgument = "none",
        reportAny = "none",
        reportUnannotatedClassAttribute = "none",
    }, {
        reportUnknownParameterType = nil,
        reportUnknownArgumentType = nil,
        reportUnknownLambdaType = nil,
        reportUnknownVariableType = nil,
        reportUnknownMemberType = nil,
        reportMissingParameterType = nil,
        reportMissingTypeArgument = nil,
        reportAny = nil,
        reportUnannotatedClassAttribute = nil,
    })
end

function M.unused_warning(choice)
    make_config(choice, {
        reportUnusedImport = "warning",
        reportUnusedVariable = "warning",
        reportUnusedFunction = "warning",
        reportUnusedClass = "warning",
        reportDuplicateImport = "warning",
    }, {
        reportUnusedImport = nil,
        reportUnusedClass = nil,
        reportUnusedFunction = nil,
        reportUnusedVariable = nil,
        reportDuplicateImport = nil,
    })
end

function M.allow_unused_return(choice)
    make_config(choice, {
        reportUnusedCallResult = "none",
    }, {
        reportUnusedCallResult = nil,
    })
end

function M.deprecated_warning(choice)
    make_config(choice, {
        reportDeprecated = "warning",
    }, {
        reportDeprecated = nil,
    })
end

function M.setup()
    local config = require("core.config").basedpyright
    M.disable_annotation_missing_check(
        config.disable_annotation_missing_check
    )
    M.unused_warning(config.unused_warning)
    M.deprecated_warning(config.deprecated_warning)
    M.allow_unused_return(config.allow_unused_return)
end

return M
