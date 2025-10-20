---@brief
---
--- https://github.com/rust-lang/rust-analyzer
---
--- rust-analyzer (aka rls 2.0), a language server for Rust
---
---
--- See [docs](https://rust-analyzer.github.io/book/configuration.html) for extra settings. The settings can be used like this:
--- ```lua
--- vim.lsp.config('rust_analyzer', {
---   settings = {
---     ['rust-analyzer'] = {
---       diagnostics = {
---         enable = false;
---       }
---     }
---   }
--- })
--- ```

-- WARNING: rustaceanvim automatically configures the rust-analyzer builtin LSP client and integrates with other Rust tools.
-- see https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#zap-quick-setup for more information
---@type vim.lsp.Config
return {

}
