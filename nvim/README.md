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
- `yarn`
- `xdg-utils` (WSL)
- `vectorcode` (`uv tool install vectorcode`)
- `ast-grep` (Optional)

The following tools will not be automatically installed by `Mason`, so you may install manually with `Mason`:

- `cpptools`
- `debugpy`
- `codelldb`
- `stylua`
- `isort`
- `black`
- `rustfmt` (use `rustup`)

For translation plugins, there are extra requirements:

- [English to Chinese Dictionary Database](https://github.com/skywind3000/ECDICT).
  Place it at `${HOME}/Documents/dict/ultimate.db`
- `festival` and `festvox-kallpc16k` (Optional for `auto_play` of `Trans.nvim`)
- [translate-shell](https://github.com/soimort/translate-shell)

## FAQs

1. **Q**: Clipboard doesn't work for `WSL`.

   **A**: This question was answered in [neovim issue#12092](https://github.com/neovim/neovim/issues/12092).

   But my solution is:

   link `~/.local/bin/clip.exe` to `/mnt/c/Windows/System32/clip.exe`and `neovim` will try to use `clip.exe` as the clipboard.

   Somethings you can't execute `.exe` (PE32+ executable) in WSL, this is actually a bug.
   You can find the solution [here](https://github.com/microsoft/WSL/issues/8952#issuecomment-1568212651).

2. **Q**: Neovim opened the file with the wrong file encoding.

   **A**: Neovim will predict the encoding, but it may be wrong.

   Use `:e ++enc=utf-8` to open file using UTF-8. This will reopen the file in **READ ONLY** mode using utf-8 encoding.

   Use `:set noreadonly` to make it editable.

3. **Q**: `rust-analyzer` only enable `default` features by default,
   how can I enable different features for different projects?

   **A**: There is many ways to do this.

   **Solution 1:**

   Add `vim.o.exrc = true` in config file. Neovim will try to execute `.nvim.lua` in the root of the workspace.

   Then put your configs in this file, for example:

   ```lua
   vim.lsp.config('rust_analyzer', {
       settings = {
           ['rust-analyzer'] = {
               cargo = {
                   features = { "feature_a", "feature_b" },
               }
           }
       }
   })
   ```

   *Neovim will ask you whether to trust this file.*

   **Solution 2:**

   Modify the global `rust_analyzer.lua` file and
   add the logic to read files like `rust-analyzer.json` in the root of the workspace.

   For example:

   ```lua
   vim.lsp.config('rust_analyzer', {
       on_new_config = function(new_config, new_root_dir)
           local json_path = new_root_dir .. "/rust-analyzer.json"
           local f = io.open(json_path, "r")
           if f then
               local content = f:read("*a")
               f:close()
               local ok, custom_settings = pcall(vim.json.decode, content)
               if ok then
                   new_config.settings = vim.tbl_deep_extend("force", new_config.settings or {}, custom_settings)
               end
           end
       end,
       settings = {
           ["rust-analyzer"] = {
               cargo = { features = {} }   -- default value
           }
       }
   })
   ```

   **Solution 3:**

   Use the `rustaceanvim` plugin.
   It will automatically search for `rust-analyzer.json` or `.rust-analyzer.json` in the root of the project and
   apply the configs.

4. **Q**: `Mason` can't install packages with `npm` properly.

   **A**: This problem has been solved in [Mason#1670](https://github.com/mason-org/mason.nvim/issues/1670).

   Sometimes, this is your `npm` goes wrong. You can check [github/orgs/community](https://github.com/orgs/community/discussions/169704).
   For example, you may mistakenly set `HTTPS_PROXY` to `127.0.0.1:7890`, which is wrong and may be `127.0.0.1:7897`.

5. Errors occur when running `MarkdownPreview` in WSL.

   `xdg-utils` should be installed. See [markdown-preview.nvim#199](https://github.com/iamcco/markdown-preview.nvim/issues/199).

   You may also have to link `cmd.exe` to a directory in `$PATH`.
