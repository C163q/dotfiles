# Neovim Config

This is the config for [`neovim`](https://github.com/neovim/neovim)

Usually, this folder should be placed at `${XDG_CONFIG_HOME}`.

## Requirements

- `neovim`>=0.11
- `curl`
- `git`
- a `C` compiler
- `debugpy`
- `wget`
- `unzip`
- `tar`
- `gzip`
- `tree-sitter CLI` (https://github.com/tree-sitter/tree-sitter)
- `node` (`Node.js`) 20 or higher
- `pylatexenc` (Optional)
- `ripgrep` (https://github.com/BurntSushi/ripgrep)
- `lua`
- `julia`
- `sqlite3`
- `rust-analyzer` (install manually instead of using `mason` for the requirement of `rustaceanvim`)
    - see [mrcjkb/rustaceanvim](https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#masonnvim-and-nvim-lspconfig) for more information
    - install: [rust-analyzer book](https://rust-analyzer.github.io/book/rust_analyzer_binary.html#rustup)
- `pkg-config`
- `npm`
- `luarocks`
- `lazygit`
- `fd`
- `jq`
- `vectorcode` (`uv tool install vectorcode`)

The following tools will not be automatically installed by `Mason`, so you may install manually with `Mason`:

- `cpptools`
- `debugpy`
- `codelldb`
- `stylua`
- `isort`
- `black`
- `rustfmt`

For translation plugins, there are extra requirements:

- [English to Chinese Dictionary Database](https://github.com/skywind3000/ECDICT).
  Place it at `${HOME}/Documents/dict/ultimate.db`
- `festival` and `festvox-kallpc16k` (Optional for `auto_play` of `Trans.nvim`)
- [translate-shell](https://github.com/soimort/translate-shell)

## FAQs

**Q**: clipboard doesn't work for `WSL`.

**A**: This question is answered in [neovim issue#12092](https://github.com/neovim/neovim/issues/12092).

But my solution is:

link `~/.local/bin/clip.exe` to `/mnt/c/Windows/System32/clip.exe`and `neovim` will try to use `clip.exe` as the clipboard.

Somethings you can't execute `.exe` (PE32+ executable) in WSL, this is actually a bug.
You can find the solution [here](https://github.com/microsoft/WSL/issues/8952#issuecomment-1568212651).
