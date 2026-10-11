# Neovim configuration

My personal [Neovim](https://github.com/neovim/neovim) configuration.

## Requirements

- Neovim 0.11 or later
- `curl`
- `git`
- A C compiler
- `debugpy`
- `wget`
- `unzip`
- `tar`
- `gzip`
- [Tree-sitter CLI](https://github.com/tree-sitter/tree-sitter)
- Node.js 20 or later
- [`ripgrep`](https://github.com/BurntSushi/ripgrep)
- `lua`
- `julia`
- `sqlite3`
- `rust-analyzer` (install outside Mason, as recommended by rustaceanvim)
  - See [rustaceanvim's Mason documentation](https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#masonnvim-and-nvim-lspconfig) for more information.
  - For installation instructions, see the [rust-analyzer book](https://rust-analyzer.github.io/book/rust_analyzer_binary.html#rustup).
- `pkg-config`
- `npm`
- `luarocks`
- `lazygit`
- `fd`
- `jq`
- `yarn`
- `libuv`
- `xdg-utils` (WSL)
- `vectorcode` (`uv tool install vectorcode`)
- `pylatexenc` (optional)
- `ast-grep` (optional)
- `pdflatex` (optional, for `snacks.image`)
- `mmdc` (optional, for `snacks.image`)
- `chafa` (optional, for `snacks.dashboard`)

Install the following tools manually through Mason:

- `cpptools`
- `debugpy`
- `codelldb`
- `stylua`
- `isort`
- `black`

Install `rustfmt` through `rustup`.

The translation plugins have the following additional dependencies:

- [English-to-Chinese dictionary database](https://github.com/skywind3000/ECDICT).
  Place the database file at `${HOME}/Documents/dict/ultimate.db`.
- `festival` and `festvox-kallpc16k` (optional, for Trans.nvim's `auto_play` feature)
- [translate-shell](https://github.com/soimort/translate-shell)

## Setup

Symlink the [`config/`](./config/) directory to `${XDG_CONFIG_HOME}/nvim`.

If `XDG_CONFIG_HOME` is unset or empty, use `~/.config`.

## Configuration

Edit [`config/lua/core/config.lua`](./config/lua/core/config.lua) to customize this configuration.

## FAQ

1. **Q**: The clipboard does not work in WSL.

   **A**: See the discussion in [Neovim issue #12092](https://github.com/neovim/neovim/issues/12092).

   In my previous WSL setup, I disabled importing the Windows `PATH`, so Neovim could not find `clip.exe`.
   My workaround is to create a symlink at `~/.local/bin/clip.exe` pointing to
   `/mnt/c/Windows/System32/clip.exe`, with `~/.local/bin` on my WSL `PATH`.

   If Windows executables fail to run in WSL with an `Exec format error`, see the
   [WSL interoperability issue and workarounds](https://github.com/microsoft/WSL/issues/8952#issuecomment-1568212651).

2. **Q**: Neovim opens a file with the wrong file encoding.

   **A**: Neovim attempts to detect the file encoding, but detection can fail.

   Use `:e ++enc=utf-8` to reopen the current file using UTF-8.

   If the buffer is marked as read-only, use `:set noreadonly` to clear that flag.

3. **Q**: How can I enable different Cargo features for different Rust projects?

   **A**: Set
   [`cargo.features`](https://rust-analyzer.github.io/book/configuration.html#cargo.features)
   for each project using one of the following approaches.

   **Using rustaceanvim and codesettings.nvim (current setup)**

   This configuration uses rustaceanvim to manage rust-analyzer and codesettings.nvim
   to load project-local settings. Create `.vscode/settings.json` in your project root
   with VS Code-style keys:

   ```json
   {
     "rust-analyzer.cargo.features": ["feature_a", "feature_b"]
   }
   ```

   Replace the example feature names with features defined in your project's `Cargo.toml`.
   Set `"rust-analyzer.cargo.features"` to `"all"` to enable all features.
   Default features remain enabled unless `"rust-analyzer.cargo.noDefaultFeatures"` is `true`.

   See [codesettings.nvim's rustaceanvim integration](https://github.com/mrjones2014/codesettings.nvim#rustaceanvim)
   for details on loading these settings.

   **Alternative 1: Project-local Lua configuration**

   Enable `vim.o.exrc = true` in your Neovim configuration, then add project-specific
   settings to a `.nvim.lua` file in your project root. For example:

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

   Neovim will ask whether to trust the file before executing it.

   **Alternative 2: Custom JSON loader**

   Add logic to the global `rust_analyzer.lua` configuration to read a project-local
   JSON file, such as `rust-analyzer.json`, and merge its contents into the LSP settings.
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

4. **Q**: Mason fails to install npm packages.

   **A**: See reports of installation failures in [Mason issue #1670](https://github.com/mason-org/mason.nvim/issues/1670).

   This can also happen if npm is misconfigured. See this [GitHub Community discussion](https://github.com/orgs/community/discussions/169704).
   For example, `HTTPS_PROXY` may point to the wrong port, such as `127.0.0.1:7890` instead of `127.0.0.1:7897`.

5. **Q**: Errors occur when running `:MarkdownPreview` in WSL.

   **A**: Install `xdg-utils`. See [markdown-preview.nvim issue #199](https://github.com/iamcco/markdown-preview.nvim/issues/199).

   You may also need to create a symlink to `cmd.exe` in a directory on your `PATH`.

## Credits

See the [Fastfetch README](../fastfetch/README.md) and the [main README](../README.md) for more information.
