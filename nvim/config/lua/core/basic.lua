local opt = vim.opt

-- line number
opt.number = true

-- indent
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
-- Round indent to multiple of 'shiftwidth'. Applies to > and < commands.
opt.shiftround = true
-- Insert indents automatically
opt.smartindent = true

-- show tabs as ">", trailing spaces as "-", and non-breakable space characters as "+"
opt.list = true

-- nowrap by default
opt.wrap = false

-- Wrap long lines at a character in breakat rather than at the last character that fits on the screen.
-- `breakat` is ` ^I!@*-+;:,./?` by default.
-- This does not insert <EOL>s in the file, it only affects the way the file is displayed, not its contents.
opt.linebreak = true
opt.listchars:append({
    trail = "·",
    -- override default "tab:> ", because some font will combine ">" and "=".
    -- This makes "=" looks like "≥", which is not good for readability.
    tab = "→ ",
})

-- Enables pseudo-transparency for the popup-menu
opt.pumblend = 10
-- Maximum number of items to show in the popup menu
opt.pumheight = 10

-- cursorline and cursorcolumn
opt.cursorline = true
opt.cursorcolumn = true

-- Allow cursor to move where there is no text in visual block mode
opt.virtualedit = "block"

-- The minimal number of screen columns to keep to the left and to the right of the cursor if 'nowrap' is set.
opt.sidescrolloff = 8
-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 4
-- Scrolling works with screen lines.  When 'wrap' is set and the first line in the window wraps
-- part of it may not be visible, as if it is above the window.
opt.smoothscroll = true

-- enable mouse
opt.mouse:append("a")

-- system clipboard
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"

-- open the split window to the right and below
opt.splitright = true
opt.splitbelow = true
-- The value of this option determines the scroll behavior when opening, closing or
-- resizing horizontal splits. `screen`: Keep the text on the same screen line.
opt.splitkeep = "screen"

-- display
opt.termguicolors = true
opt.signcolumn = "yes" -- Always show the signcolumn
opt.winborder = "rounded"
opt.fillchars = {
    foldopen = "󰍝",
    foldclose = "󰍟",
    foldsep = "│",
}
opt.winminwidth = 5 -- Minimum window width

opt.updatetime = 250 -- Save swap file and trigger CursorHold
opt.timeoutlen = 500 -- Lower than default (1000) to quickly trigger which-key
opt.spelllang = { "en" }

-- Changes the effect of the :mksession command.
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Command-line completion mode
opt.wildmode = "longest:full,full"

-- The last window and ONLY the last window will always have a status line
-- For 2, there are always status lines and every window own one in different position,
-- but only the last window is highlighted.
-- For 3, there is always a status line at the bottom of the screen, regardless of how many windows are open.
opt.laststatus = 3

local user_config = require("core.config")
opt.relativenumber = user_config.relative_line_number
opt.ignorecase = user_config.search_ingore_case

-- Override the 'ignorecase' option if the search pattern contains uppercase characters.
opt.smartcase = true

-- undo
opt.undofile = user_config.undo_file
opt.undolevels = user_config.undo_levels

-- close a modified buffer will not fail, but will ask for confirmation
opt.confirm = true

-- vim.o.statuscolumn='%s%=%l%{foldlevel(v:lnum) > 0 ? (foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "󰍝" : "󰍟") : "│") : " " }'
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = "indent"

opt.statuscolumn = [[%!v:lua.require'core.modify.snacks-statuscolumn'.get()]]
