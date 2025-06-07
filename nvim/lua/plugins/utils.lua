vim.opt.termguicolors = true
vim.opt.mouse:append("a")

return {
    -- https://github.com/nvim-lualine/lualine.nvim
    -- lualine: A blazing fast and easy to configure Neovim statusline written in Lua.
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            sections = {
                lualine_c = {
                    {
                        'filename',
                        file_status = true,
                        newfile_status = true,
                        path = 0,

                        shorting_target = 40,
                        symbols = {
                            modified = '[+]',
                            readonly = '[-]',
                            unnamed = '[No Name]',
                            newfile = '[New]',
                        }
                    }
                }
            },
        }
    },

    -- https://github.com/nvim-neo-tree/neo-tree.nvim
    -- Neo-tree is a Neovim plugin to browse the file system and other tree like structures in whatever style suits you, 
    -- including sidebars, floating windows, netrw split style, or all of them at once!
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        lazy = false, -- neo-tree will lazily load itself
        ---@module "neo-tree"
        ---@type neotree.Config?
        opts = {
            -- fill any relevant options here
            close_if_last_window = false,
            enable_git_status = true,
            default_component_configs = {
                git_status = {
                    symbols = {
                        -- Change type
                        added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                        modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
                        deleted = "✖", -- this can only be used in the git_status source
                        renamed = "󰁕", -- this can only be used in the git_status source
                        -- Status type
                        untracked = "",
                        ignored = "",
                        unstaged = "󰄱",
                        staged = "",
                        conflict = "",
                    },
                },
                window = {
                    position = "left",
                    width = 0.2,
                }
            }
        },
    },

    -- https://github.com/nvim-treesitter/nvim-treesitter/tree/main
    -- The nvim-treesitter plugin provides
    --   functions for installing, updating, and removing tree-sitter parsers;
    --   a collection of queries for enabling tree-sitter features built into Neovim for these languages;
    --   a staging ground for treesitter-based features considered for upstreaming to Neovim.
    {
        {
            'nvim-treesitter/nvim-treesitter',
            lazy = false,
            branch = 'main',
            build = ":TSUpdate",
            config = function()
                require('nvim-treesitter.config').setup(opts)
                require('nvim-treesitter').setup()

                local ensure_installed = {
                    'rust', 'javascript', 'c', 'lua',
                    'cmake', 'cpp', 'json', 'jsonc',
                    'markdown', 'python', 'yaml', 'bash'
                }

                require('nvim-treesitter').install(ensure_installed):wait(30000)

                -- enable highlight
                vim.api.nvim_create_autocmd('FileType', {
                    pattern = { '<filetype>' },
                    callback = function() vim.treesitter.start() end,
                })

                -- enable folds
                vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

            end
        },
    },

    -- https://github.com/akinsho/bufferline.nvim
    -- bufferline.nvim: A snazzy buffer line (with tabpage integration) for Neovim built using lua.
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                close_command = "bdelete! %d",
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = {'close'}
                },
                indicator = {
                    style = 'underline',
                    icon = "_"
                },
                pick = {
                    alphabet = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                },
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,
                -- 左侧让出 nvim-tree 的位置
                offsets = {{
                    filetype = "neo-tree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "center"
                }},
                custom_filter = function(buf_number, buf_numbers)
                    -- filter out filetypes you don't want to see
                    if vim.bo[buf_number].filetype ~= "neotree"
                        and vim.bo[buf_number].buftype ~= "terminal"
                    then
                        return true
                    end
                end,
            }
        }
    },

    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    -- render-markdown.nvim: Plugin to improve viewing Markdown files in Neovim
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
        -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },

    -- https://github.com/akinsho/toggleterm.nvim
    -- toggleterm.nvim: A neovim plugin to persist and toggle multiple terminals during an editing session
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {}
    },

    -- https://github.com/nvim-telescope/telescope.nvim
    -- telescope.nvim: Gaze deeply into unknown regions using the power of the moon.
    {
        'nvim-telescope/telescope.nvim',
        -- branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    -- https://github.com/kevinhwang91/nvim-ufo
    -- nvim-ufo: The goal of nvim-ufo is to make Neovim's fold look modern and keep high performance.
    {
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async' },
        config = function()
            vim.o.statuscolumn='%=%l%s%{foldlevel(v:lnum) > 0 ? (foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "󰍝" : "󰍟") : "│") : " " }'
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- Tell the server the capability of foldingRange,
            -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
            local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
            for _, ls in ipairs(language_servers) do
                require('lspconfig')[ls].setup({
                    capabilities = capabilities
                    -- you can add other fields for setting up lsp server in this table
                })
            end

            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (' 󰁂 %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, {chunkText, hlGroup})
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, {suffix, 'MoreMsg'})
                return newVirtText
            end

            require('ufo').setup({
                fold_virt_text_handler = handler
            })
        end
    },

--[[
    -- https://github.com/rcarriga/nvim-notify
    -- nvim-notify: A fancy, configurable, notification manager for NeoVim
    -- DISABLED for messages truncated when `max_width` set.
    {
        "rcarriga/nvim-notify",
        opts = {
            max_width = 30,
            max_height = 20,
            wrap_message = true,
        }
    },
--]]

    -- https://github.com/folke/noice.nvim
    -- Noice (Nice, Noise, Notice): Highly experimental plugin that 
    -- completely replaces the UI for messages, cmdline and the popupmenu.
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            presets = {
                bottom_search = false,  -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true,   -- long messages will be sent to a split
                inc_rename = false,     -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = true,  -- add a border to hover docs and signature help
            },
            messages = {
                enabled = false,
            },
            popupmenu = {
                enabled = false,
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            "nvim-treesitter/nvim-treesitter",
        }
    }
}
