
-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_semanticTokens
-- https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316

vim.api.nvim_create_augroup('CustomHighlight', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
    group = 'CustomHighlight',
    pattern = '*',
    callback = function()
    end
})

vim.api.nvim_set_hl(0, 'SnacksIndent', { fg = "#636779" })

vim.api.nvim_set_hl(0, 'Type', { fg='#63a7e4' })
vim.api.nvim_set_hl(0, 'Function', { fg='#f4efa3' })
vim.api.nvim_set_hl(0, 'Character', { link='String' })
vim.api.nvim_set_hl(0, 'Operator', { fg='#e4eff4' })
vim.api.nvim_set_hl(0, 'Comment', { fg='#9399B2' })
vim.api.nvim_set_hl(0, '@function.builtin', { fg='#f4d8a3' })
vim.api.nvim_set_hl(0, '@property', { fg='#abcdf9' })
vim.api.nvim_set_hl(0, '@variable.member', { fg='#cbf5ef' })
vim.api.nvim_set_hl(0, '@variable.parameter', { fg='#bccddf' })
vim.api.nvim_set_hl(0, '@parameter', { fg='#bccddf' })
vim.api.nvim_set_hl(0, '@keyword', { fg='#cba6f7' })
vim.api.nvim_set_hl(0, '@lsp.type.variable', { fg='#a0edff' })
vim.api.nvim_set_hl(0, '@lsp.type', { fg='#63a7e4' })
vim.api.nvim_set_hl(0, '@type', { fg='#63a7e4' })
vim.api.nvim_set_hl(0, '@type.builtin', { fg='#d17676' })
-- vim.api.nvim_set_hl(0, '@lsp.type.enum', { fg='#64df5f' })
-- vim.api.nvim_set_hl(0, '@lsp.type.struct', { fg='#64df5f' })
-- vim.api.nvim_set_hl(0, '@lsp.type.interface', { fg='#acde60' })
vim.api.nvim_set_hl(0, '@string.regexp', { fg='#fbb0b0' })
vim.api.nvim_set_hl(0, '@string.regex', { fg='#fbb0b0' })
vim.api.nvim_set_hl(0, '@operator', { link='Operator' })
vim.api.nvim_set_hl(0, '@lsp.type.typeParameter', { fg='#cd86a9' })
-- vim.api.nvim_set_hl(0, '@lsp.type.number', { fg='#9eef82' })
vim.api.nvim_set_hl(0, '@lsp.mod.documentation', { bold = true })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp="#F9E2AF" })

-- C/C++ Specific
vim.api.nvim_create_augroup('CCppSpeicalHighlight', { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "cxx", "C", "h", "hpp" },
    callback = function()
        vim.schedule(function ()
            vim.api.nvim_set_hl(0, '@type.builtin', { fg='#42ceaf' })
            vim.api.nvim_set_hl(0, '@lsp.type.class.cpp', { fg='#42ceaf' })
            vim.api.nvim_set_hl(0, 'cType', { fg='#63a7e4' })
            vim.api.nvim_set_hl(0, 'cppStructure', { link='Structure' })
            vim.api.nvim_set_hl(0, 'Structure', { fg='#63a7e4' })
            vim.api.nvim_set_hl(0, 'StorageClass', { fg='#63a7e4', italic = true })
            vim.api.nvim_set_hl(0, '@lsp.type.bracket.cpp', { fg='#e4eff4' })
            vim.api.nvim_set_hl(0, 'cppOperator', { fg='#f4efa3' })
            vim.api.nvim_set_hl(0, 'cOperator', { link='cType' })
            vim.api.nvim_set_hl(0, '@variable.builtin', { fg='#6bf9ff' })
            vim.api.nvim_set_hl(0, '@lsp.type.unknown.cpp', { fg='#ffd8d8' })
        end)
    end
})

-- Rust Specific
vim.api.nvim_create_augroup('RustSpecialHighlight', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = { "rust" },
    callback = function ()
        vim.schedule(function ()
            vim.api.nvim_set_hl(0, 'rustMacro', { fg='#f7bf84' })
            vim.api.nvim_set_hl(0, '@lsp.type.macro.rust', { link='rustMacro' })
            vim.api.nvim_set_hl(0, '@lsp.typemod.macro.defaultLibrary', { fg='#efaa5f' })
            vim.api.nvim_set_hl(0, '@lsp.type.struct.rust', { fg='#42ce9e' })
            vim.api.nvim_set_hl(0, '@lsp.type.enum.rust', { link='@lsp.type.struct.rust' })
            vim.api.nvim_set_hl(0, '@lsp.type.builtinType.rust', { fg='#63a7e4' })
            vim.api.nvim_set_hl(0, '@lsp.typemod.enum.defaultLibrary.rust', { fg='#51d9ab' })
            vim.api.nvim_set_hl(0, '@module', { fg='#abb6fe', italic=true })
            vim.api.nvim_set_hl(0, '@lsp.type.attributeBracket.rust', { link='rustAttribute' })
            vim.api.nvim_set_hl(0, 'StorageClass', { fg='#f9d0af', italic=true })
        end)
    end
})

vim.api.nvim_set_hl(0, 'SnacksIndentChunk', { fg="#faf4cd" })
vim.api.nvim_set_hl(0, 'SnacksIndentScope', { fg="#dcd1da" })

