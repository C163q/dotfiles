---@brief
---
--- https://detachhead.github.io/basedpyright
---
--- `basedpyright`, a static type checker and language server for python

---@type vim.lsp.Config
return {
    settings = {
        basedpyright = {
            analysis = {
                diagnosticSeverityOverrides = {
                    -- reportUnusedVariable = "warning", -- or anything
                },
            },
        },
    },
}
