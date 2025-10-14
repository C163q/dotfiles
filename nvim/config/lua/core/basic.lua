local opt = vim.opt

-- 行号
opt.number = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- 防止包裹
opt.wrap = false

-- 光标行
opt.cursorline = true
opt.cursorcolumn = true

-- 启用鼠标
opt.mouse:append("a")

-- 系统剪贴板
opt.clipboard:append("unnamedplus")
vim.g.clipboard="win32yank"

-- 默认新窗口右和下
opt.splitright = true
opt.splitbelow = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"
vim.o.winborder = "rounded"
opt.fillchars='foldopen:󰍝,foldclose:󰍟,foldsep:│'

local custom_config = require('core.config')
if custom_config.relativeLineNumber then
    opt.relativenumber = true
end

opt.statuscolumn = [[%!v:lua.require'core.modify.snacks-statuscolumn'.get()]]


