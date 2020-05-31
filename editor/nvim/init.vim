call plug#begin('~/.config/nvim/plugins')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'Yggdroot/indentLine'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Colourschemes
" Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'

" Language syntax plugins
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'plasticboy/vim-markdown'
call plug#end()

"-------- Colourscheme --------
if !has('gui_running')
    set t_Co=256
endif
if match($TERM, '-256color')
    set termguicolors
endif
syntax on

" Gruvbox
" colorscheme gruvbox
" let g:gruvbox_contrast_dark="hard"
" let g:gruvbox_contrast_light="hard"

" Seoul256 - Dark
" set background=dark
" let g:seoul256_background=234
" colorscheme seoul256

" Seoul256 - Light
set background=light
let g:seoul256_background=252
colorscheme seoul256

"-------- Editor Configuration --------
"
let mapleader = "\<Space>"  " Map Leader to Space
let g:netrw_banner=0  " Hide the banner in netrw
let g:netrw_liststyle=3  " Use tree view when browsing files
let g:tex_conceal='' " Don't hide anything in LaTeX

set autoread  " Automatically apply changes if file changes outside of nvim
set colorcolumn=100
set conceallevel=0
set encoding=utf8
set guicursor=
set hidden
set laststatus=2
set mouse=a
set number relativenumber
set ruler
set scl=yes  " Show sign column
set shortmess+=c
set showmatch  " Show matching parentheses
set showtabline=2  " Show file tabs
set ttyfast
set updatetime=100  " Reduce update time to show git diffs
set visualbell  " Turn off bell sound

" Search configuration
set incsearch
set ignorecase
set smartcase

" Tabbing
set expandtab
set shiftwidth=4
set smarttab
set softtabstop=0
set tabstop=8

" Splits that make sense
set splitbelow
set splitright

" Jump to last-edit position when opening files
if has("autocmd")
    au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1
                \&& line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"-------- Key Mappings and Commands --------

" Stop accidentally opening help
map <F1> <Esc>
imap <F1> <Esc>

" Save and quit shortcuts
nmap <Leader>w :w<CR>
nmap <Leader>q :q!<CR>

" Faster buffer switching
nmap <Leader>gp :bp<CR>
nmap <Leader>gn :bn<CR>

" Move cursor on each line for wrapped line
nnoremap j gj
nnoremap k gk

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

" Shortcut for updating plugins
command! PU PlugInstall | PlugUpgrade
command! PC PlugClean!
command! PUP PlugUpgrade

" Fast capitalization
inoremap <c-u> <esc>bveU<esc>Ea

"-------- Autocommands --------

" File detection
autocmd BufRead *.md set filetype=markdown
autocmd BufRead journal set filetype=journal
autocmd BufRead *.tex set filetype=tex

" Set specific line length columns for different files
" au FileType sh set colorcolumn=100
" au FileType vim set colorcolumn=100
" au FileType journal set colorcolumn=100

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
let g:vim_markdown_conceal_code_blocks=0

" git-commentary additions for unsupported languages
autocmd FileType rust setlocal commentstring=//\ %s

" lightline config
let g:lightline = {
    \ 'colorscheme': 'seoul256',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'filename', 'readonly', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'fileencoding', 'filetype' ] ]
    \ },
    \ 'inactive': {
    \   'left': [ [ 'filename', 'modified' ] ],
    \ },
    \ 'component_function': {
    \   'gitbranch': 'TruncateGitBranch'
    \ },
    \ }

" Sometimes branch names are too long
function! TruncateGitBranch()
    let len_limit=30
    " This can be any function that returns the current HEAd
    let head = FugitiveHead()
    return len(head) > len_limit ? strpart(head, 0, len_limit) . "..." : head
endfunction

" coc.nvim
let g:coc_global_extensions = [
    \ 'coc-python'.
    \ 'coc-rust-analyzer',
    \ 'coc-json'
]
