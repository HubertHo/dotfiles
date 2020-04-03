call plug#begin('~/.config/nvim/plugins')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'morhetz/gruvbox'
Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'

" Language syntax plugins
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'plasticboy/vim-markdown'
call plug#end()

"-------- Colour scheme --------
if !has('gui_running')
    set t_Co=256
endif
if match($TERM, '-256color')
    set termguicolors
endif
set background=light
colorscheme gruvbox
syntax on

let g:gruvbox_contrast_dark="hard"
let g:gruvbox_contrast_light="hard"

"-------- Editor Configuration --------
set colorcolumn=100
set encoding=utf8
set guicursor=
set laststatus=2
set ruler
set mouse=a
set number relativenumber
set showmatch  " Show matching parentheses

" Show file tabs
set showtabline=2

" Map Leader to Space
let mapleader = "\<Space>"

" Save and quit shortcuts
nmap <Leader>w :w<CR>
nmap <Leader>q :q!<CR>

" Tabbing
set tabstop=8
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

" Turn off bell sound
set visualbell

" Splits that make sense
set splitright
set splitbelow

" Automatically apply changes if file changes outside of nvim
set autoread

" Move cursor on each line for wrapped line
nnoremap j gj
nnoremap k gk

" Stop accidentally opening help
map <F1> <Esc>
imap <F1> <Esc>

" Set specific line length columns for different files
au FileType sh set colorcolumn=100
au FileType vim set colorcolumn=100
au FileType journal set colorcolumn=100

" Hide the banner in netrw
let g:netrw_banner=0

" Use tree view when browsing files
let g:netrw_liststyle=3

" Search configuration
set incsearch
set ignorecase
set smartcase

" Edit config shortcuts
nnoremap <Leader>ev :tab new $MYVIMRC<CR>
nnoremap <Leader>sv :so $MYVIMRC<CR>
nnoremap <Leader>eb :tab new ~/.bashrc<CR>
nnoremap <Leader>elc :tab new ~/.alacritty.yml<CR>
nnoremap <Leader>etodo :tab new ~/.todo<CR>
nnoremap <Leader>jnl :tab new ~/Documents/journal<CR>

" ShowDirectoryTree
command! SDT tab new | Explore
nnoremap <Leader>sdt :SDT<CR>

" Show sign column
set scl=yes

" Reduce update time to show git diffs
set updatetime=100

" Jump to last-edit position when opening files
if has("autocmd")
    au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"-------- Autocommands --------
"
" File detection
autocmd BufRead *.md set filetype=markdown
autocmd BufRead journal set filetype=journal

"-------- Plugin Configuration --------

" vim-signify configs
let g:signify_sign_add='+'
let g:signify_sign_delete='-'
let g:signify_sign_delete_first_line='-'
let g:signify_sign_change='!'
highlight SignifySignAdd ctermfg=green ctermbg=green guifg=#00ff00 guibg=#00ff00
highlight SignifySignChange ctermfg=yellow ctermbg=yellow guifg=#ffff00 guibg=#ffff00
highlight SignifySignDelete ctermfg=red ctermbg=red guifg=#ff0000 guibg=#ff0000

" vim-markdown configs
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_conceal=0

" git-commentary additions for unsupported languages
autocmd FileType rust setlocal commentstring=//\ %s

" lightline config
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'filename', 'readonly', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'FugitiveHead'
    \ },
    \ }
