-- https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1429989436
-- stop snippet when go to normal mode
-- Shouldn't going to normal mode cancel the "session"? #258
--
-- NOTE: solved because of blink.cmp config
--[[
-- In the config of `L3MON4D3/LuaSnip`
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*",
    callback = function()
        if
            (
                (vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n")
                or (vim.v.event.old_mode == "i" and vim.v.event.new_mode == "n")
            )
            and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require("luasnip").session.jump_active
        then
            require("luasnip").unlink_current()
        end
    end,
})
--]]

local event_presets = require("core.config").event_presets

return {
    -- https://github.com/rafamadriz/friendly-snippets
    -- Friendly Snippets: Snippets collection for a set of different programming languages.
    {
        "rafamadriz/friendly-snippets",
        event = event_presets.start_edit,
    },

    -- https://github.com/L3MON4D3/LuaSnip
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        dependencies = { "rafamadriz/friendly-snippets" },
        event = event_presets.start_edit,
        config = function()
            -- On Neovim 0.11+ with vim.lsp.config, you may skip configuring LSP Capabilities.
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
        keys = {
            {
                "<Leader>x",
                function()
                    if require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()] then
                        require("luasnip").unlink_current()
                    end
                end,
                noremap = true,
                desc = "clear snippet jump",
            },
            {
                "<C-Tab>",
                function()
                    if require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()] then
                        require("luasnip").unlink_current()
                    end
                end,
                mode = { "i", "n" },
                { noremap = true, desc = "clear snippet jump" },
            },
        },
    },

    -- https://github.com/folke/lazydev.nvim
    -- lazydev.nvim is a plugin that properly configures LuaLS for editing your Neovim config
    -- by lazily updating your workspace libraries.
    ---@Warning: NOT compatible with folke/neodev.nvim!!!!!!!
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        event = event_presets.start_edit,
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- https://github.com/windwp/nvim-autopairs
    -- nvim-autopairs: A super powerful autopair plugin for Neovim that supports multiple characters.
    {
        "windwp/nvim-autopairs",
        event = event_presets.start_insert,
        config = function()
            local npairs_ok, npairs = pcall(require, "nvim-autopairs")
            if not npairs_ok then
                return
            end

            npairs.setup({
                check_ts = true,
                ts_config = {
                    lua = { "string", "source" },
                    javascript = { "string", "template_string" },
                },
                fast_wrap = {
                    map = "<M-e>",
                    chars = { "{", "[", "(", '"', "'" },
                    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
                    end_key = "$",
                    keys = "qwertyuiopzxcvbnmasdfghjkl",
                    check_comma = true,
                    highlight = "Search",
                    highlight_grey = "Comment",
                },
            })

            -- This allows cmp to add the branket automatically when autocompleting.
            local cmp_status_ok, cmp = pcall(require, "cmp")
            if not cmp_status_ok then
                return
            end
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
        end,
    },
}
