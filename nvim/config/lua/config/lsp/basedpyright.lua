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
        reportUnknownParameterType = "warning",
        reportUnknownArgumentType = "warning",
        reportUnknownLambdaType = "warning",
        reportUnknownVariableType = "warning",
        reportUnknownMemberType = "warning",
        reportMissingParameterType = "warning",
        reportMissingTypeArgument = "warning",
        reportAny = "warning",
        reportUnannotatedClassAttribute = "warning",
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
        reportUnusedImport = "none",
        reportUnusedClass = "none",
        reportUnusedFunction = "none",
        reportUnusedVariable = "none",
        reportDuplicateImport = "none",
    })
end

function M.basedpyright_allow_unused_return(choice)
    basedpyright_config(choice, {
        reportUnusedCallResult = "none",
    }, {
        reportUnusedCallResult = "warning",
    })
end

function M.basedpyright_deprecated_warning(choice)
    basedpyright_config(choice, {
        reportDeprecated = "warning",
    }, {
        reportDeprecated = "none",
    })
end

return M
