call plug#begin('~/.config/nvim/plugins')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
call plug#end()

" git-commentary addition for Rust
autocmd FileType rust setlocal commentstring=//\ %s

" Editor Configs
colorscheme deus
set background=dark
set colorcolumn=100
set encoding=utf8
set guicursor=
set laststatus=0 ruler
set mouse=a
set number

" Show file tabs
set showtabline=2

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
