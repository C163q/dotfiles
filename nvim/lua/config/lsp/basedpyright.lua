
if _G.MyCustomSettings.basedpyrightTypeCheck then
    vim.lsp.config('basedpyright', {
        settings = {
            basedpyright = {
                analysis = {
                    diagnosticSeverityOverrides = {}
                }
            }
        }
    })
else
    vim.lsp.config('basedpyright', {
        settings = {
            basedpyright = {
                analysis = {
                    diagnosticSeverityOverrides = {
                        reportUnknownParameterType = "none",
                        reportUnknownArgumentType = "none",
                        reportUnknownLambdaType = "none",
                        reportUnknownVariableType = "none",
                        reportUnknownMemberType = "none",
                        reportMissingParameterType = "none",
                        reportMissingTypeArgument = "none",
                        reportAny = "none",
                        reportUnannotatedClassAttribute = "none"
                    }
                }
            }
        }
    })
end


