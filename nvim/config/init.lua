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
-- node (Node.js) 20 or higher
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
-- pkg-config
-- npm
-- luarocks
-- lazygit
-- fd
-- jq
-- vectorcode (uv tool install vectorcode)
--
---@Mason_extra_install:
-- cpptools
-- debugpy
-- codelldb
-- stylua
-- isort
-- black
-- rustfmt
--
---@WSL_install
-- win32yank.exe
--     | Install it on Windows and put it in PATH
--     | e.g. ln -s /mnt/d/path/to/win32yank.exe /usr/local/bin/win32yank.exe
--     | If you can't execute it in WSL, here is the solution (a bug in WSL):
--     | https://github.com/microsoft/WSL/issues/8952#issuecomment-1568212651
--     |     sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
--     |     sudo systemctl restart systemd-binfmt
--
---@translate_plugin
-- English to Chinese Dictionary Database: https://github.com/skywind3000/ECDICT
--     | path: $HOME/Documents/dict/ultimate.db
-- festival festvox-kallpc16k (Optional for auto_play of Trans.nvim)
-- translate-shell (https://github.com/soimort/translate-shell)

