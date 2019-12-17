:colorscheme deus
:set background=dark

" Stop wsl from ringing
:set visualbell

" Editor
:set encoding=utf8
:set number
:set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Vim plugins
call plug#being('~/.vim/plugged')

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

call plug#end()
