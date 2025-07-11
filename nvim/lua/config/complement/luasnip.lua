
-- On Neovim 0.11+ with vim.lsp.config, you may skip configuring LSP Capabilities.

require("luasnip.loaders.from_vscode").lazy_load()

-- Configuration option: forget the current snippet
-- https://github.com/L3MON4D3/LuaSnip/issues/656#issuecomment-1313310146
local luasnip = require('luasnip')

local unlinkgrp = vim.api.nvim_create_augroup(
  'UnlinkSnippet',
  { clear = true }
)

vim.api.nvim_create_autocmd('CursorMoved', {
  group = unlinkgrp,
  pattern = {'s:n', 'i:*'},
  desc = 'Forget the current snippet',
  callback = function(evt)
    if
      luasnip.session
      and luasnip.session.current_nodes[evt.buf]
      and not luasnip.session.jump_active
    then
      luasnip.unlink_current()
    end
  end,
})

