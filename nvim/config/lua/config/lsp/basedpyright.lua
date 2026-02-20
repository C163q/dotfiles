local M = {}

---@param choice boolean
---@param overrides table | nil
---@param original table | nil
local function basedpyright_config(choice, overrides, original)
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
function M.basedpyright_disable_annotation_missing_check(choice)
    basedpyright_config(choice, {
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

function M.basedpyright_unused_warning(choice)
    basedpyright_config(choice, {
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

function M.basedpyright_allow_unused_return(choice)
    basedpyright_config(choice, {
        reportUnusedCallResult = "none",
    }, {
        reportUnusedCallResult = nil,
    })
end

function M.basedpyright_deprecated_warning(choice)
    basedpyright_config(choice, {
        reportDeprecated = "warning",
    }, {
        reportDeprecated = nil,
    })
end

function M.setup()
    local config = require("core.config")
    M.basedpyright_disable_annotation_missing_check(
        config.basedpyright_disable_annotation_missing_check
    )
    M.basedpyright_unused_warning(config.basedpyright_unused_warning)
    M.basedpyright_deprecated_warning(config.basedpyright_deprecated_warning)
    M.basedpyright_allow_unused_return(config.basedpyright_allow_unused_return)
end

return M
