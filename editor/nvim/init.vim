let g:ale_disable_lsp = 1

call plug#begin(stdpath('data').'/plugged')
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-signify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'Yggdroot/indentLine'

" Neovim specific plugins
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

set background=dark
colorscheme base16-gruvbox-hard

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
set nocompatible
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

" coc-nvim
let g:coc_global_extensions = [
    \ 'coc-jedi',
    \ 'coc-tsserver',
    \ 'coc-texlab',
    \ 'coc-rust-analyzer',
    \ 'coc-json'
    \ ]

" Use Tab for trigger completion with characters ahead
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use Tab to navigate autocompletion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" fuzzy finder
nnoremap <leader>s :Rg $PWD<CR>
nnoremap <leader>f :GFile $PWD<CR>
nnoremap <leader>b :Buffers<CR>

" ALE
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_filetype_changed = 0
let g:ale_linters = {"python": ["flake8"], "javascript": ["eslint"]}
let g:ale_python_flake8_executable = "/home/hubert/.local/bin/flake8"
let g:ale_python_flake8_options = "--config /home/hubert/.config/flake8"
let g:ale_python_flake8_use_global = 1

" nvim-treesitter
lua <<EOF
require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "javascript",
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
