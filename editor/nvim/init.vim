call plug#begin('~/.config/nvim/plugins')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
call plug#end()

" Editor
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
