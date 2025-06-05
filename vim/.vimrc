call plug#begin()

" List your plugins here
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'
Plug 'valloric/youcompleteme'

call plug#end()

colorscheme molokai

let g:ycm_enable_semantic_highlighting=1
let g:ycm_auto_trigger=1

syntax on
filetype on
au BufRead,BufNewFile *.sv set filetype=systemverilog
au BufRead,BufNewFile *.v  set filetype=verilog

filetype plugin indent on
set number
set autoindent
set showmatch

set shiftwidth=4
set softtabstop=4
set ts=4
set expandtab

set hlsearch
" set cursorline
" set cursorcolumn

set guifont=Monospace\ 16

" inoremap ( ()<Esc>i
" inoremap { {}<Esc>i
" inoremap [ []<Esc>i
" inoremap " ""<Esc>i
" inoremap ' ''<Esc>i

nnoremap <C-S-v> <C-v>
noremap <C-z> <Undo>
inoremap <C-z> <Esc><Undo>i
noremap <C-Up> 5<Up>
noremap <C-Down> 5<Down>
inoremap <C-Up> <Esc>5<Up>i
inoremap <C-Down> <Esc>5<Down>i
nnoremap <C-q> :NERDTreeToggle<Enter>

inoremap <silent> <C-s> <Plug>(YCMToggleSignatureHelp)

let maplocalleader=","
nnoremap <silent> <localleader>h <Plug>(YCMToggleInlayHints)
nnoremap <localleader>n :NERDTreeFocus<Enter>

