call plug#begin(stdpath('data').'/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'

" Neovim specific plugins
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Language syntax plugins
Plug 'rust-lang/rust.vim'
Plug 'plasticboy/vim-markdown'
call plug#end()


"-------- Utilities --------
" Avoid loading a file that does not exist
function! SafelyLoadFile(file)
    if filereadable(expand(a:file))
        exe 'source' a:file
    endif
endfunction

" Sometimes branch names are too long
function! TruncateGitBranch()
    let len_limit=30
    " This can be any function that returns the current HEAD
    let head = FugitiveHead()
    return len(head) > len_limit ? strpart(head, 0, len_limit) . "..."
        \ : head
endfunction

"-------- Colourscheme --------
if !has('gui_running')
    set t_Co=256
endif
if match($TERM, '-256color')
    set termguicolors
endif
syntax on

set background=light
colorscheme one-nvim

" nvim-treesitter
lua <<EOF
require "nvim-treesitter.configs".setup {
    ensure_installed = {
        "javascript",
        "json",
        "latex",
        "python",
        "toml",
        "tsx",
        "typescript",
        "yaml"
    },
    highlight = {
        enable = true,
    },
}
EOF

"-------- LSP Config --------
lua <<EOF
local lspconfig = require 'lspconfig'
local completion = require 'completion'

lspconfig.jedi_language_server.setup{
    on_attach=completion.on_attach
}

lspconfig.rust_analyzer.setup{
    on_attach=completion.on_attach
}

lspconfig.tsserver.setup{
    on_attach=completion.on_attach
}
EOF

" Completion settings
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Manually trigger completion using ctrl + space
imap <silent> <c-space> <Plug>(completion_trigger)

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

"-------- Editor Configuration --------
let mapleader = "\<Space>"  " Map Leader to Space
let g:netrw_banner=0  " Hide the banner in netrw
let g:netrw_liststyle=3  " Use tree view when browsing files

" Automatically apply changes if file changes outside of nvim
set autoread
set colorcolumn=101
set conceallevel=0
set encoding=utf8
set formatoptions+=tc
set formatoptions+=r
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

filetype plugin on

"-------- Key Mappings and Commands --------
" Map ; as :
nnoremap ; :

" Stop accidentally opening help
map <F1> <Esc>
imap <F1> <Esc>

" Save and quit shortcuts
nmap <Leader>w :w<CR>
nmap <Leader>q :q!<CR>

" Move cursor on each line for wrapped line
nnoremap j gj
nnoremap k gk

" Edit config shortcuts
nnoremap <Leader>ev :tab new $MYVIMRC<CR>
nnoremap <Leader>sv :so $MYVIMRC<CR>
nnoremap <Leader>eb :tab new ~/.bashrc<CR>
nnoremap <Leader>elc :tab new ~/.alacritty.yml<CR>

" ShowDirectoryTree
command! SDT tab new | Explore
nnoremap <Leader>sdt :SDT<CR>

" Shortcut for updating plugins
command! PU PlugInstall | PlugUpgrade
command! PC PlugClean!
command! PUP PlugUpgrade

" Fast capitalization
inoremap <c-u> <esc>bveU<esc>Ea

" No arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

"-------- Plugin Configuration --------
" vim-signify configs
let g:signify_sign_add='+'
let g:signify_sign_delete='-'
let g:signify_sign_delete_first_line='-'
let g:signify_sign_change='!'
highlight SignifySignAdd ctermfg=green ctermbg=green guifg=#00ff00 guibg=#00ff00
highlight SignifySignChange ctermfg=yellow ctermbg=yellow guifg=#ffff00 guibg=#ffff00
highlight SignifySignDelete ctermfg=red ctermbg=red guifg=#ff0000 guibg=#ff0000

" lightline config
let g:lightline = {
    \ 'colorscheme': 'powerline',
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
