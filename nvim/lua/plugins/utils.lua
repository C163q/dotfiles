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
                -- 左侧让出 nvim-tree 的位置
                offsets = {{
                    filetype = "neo-tree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left"
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
}
