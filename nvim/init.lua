require('core.preload')
require('core.keymap')
require('config.lazy')
require('core.basic')
require('config.config_init')
require('core.lsp_enable')
require('core.user_command')
require('core.lsp_highlight')

---@requirement:
-- curl
-- git
-- C compiler
-- debugpy
-- Nerd Font
-- wget
-- unzip
-- tar
-- gzip
-- tree-sitter CLI (https://github.com/tree-sitter/tree-sitter)
-- node (Node.js)
-- pylatexenc (Optional)
-- ripgrep (https://github.com/BurntSushi/ripgrep)
-- lua
-- julia
-- sqlite3
-- rust-analyzer (install manually instead of using mason for the requirement of rustaceanvim)
--     | see https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#masonnvim-and-nvim-lspconfig for more information
--     | install: https://rust-analyzer.github.io/book/rust_analyzer_binary.html#rustup
-- win32yank.exe (if using WSL)
--     | see https://github.com/neovim/neovim/issues/12092 for clipboard issue in WSL
--     | see https://github.com/equalsraf/win32yank for win32yank.exe
--
---@Mason_extra_install:
-- cpptools
-- debugpy
-- codelldb

