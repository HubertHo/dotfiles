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
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'rktjmp/lush.nvim'

" Treesitter colors
Plug 'npxbr/gruvbox.nvim'
Plug 'Th3Whit3Wolf/one-nvim'

" Language syntax plugins
Plug 'rust-lang/rust.vim'
Plug 'plasticboy/vim-markdown'
call plug#end()

"-------- Utilities --------
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

lua <<EOF
-- nvim-treesitter
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

-- lspconfig
local lspconfig = require 'lspconfig'
lspconfig.jedi_language_server.setup{}
lspconfig.rust_analyzer.setup{}
lspconfig.tsserver.setup{}
EOF

"-------- Editor Configuration --------
let mapleader = "\<Space>"  " Map Leader to Space

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

lua <<EOF
-- lightline
vim.g.lightline = {
    colorscheme = "one",
    active = {
        left = {
            {"mode", "past"},
            {"gitbranch", "filename", "readonly", "modified"}
        },
        right = {
            {"lineinfo"},
            {"fileencoding", "filetype"},
        },
    },
    inactive = {
        left = {
            {"filename", "modified"},
        }
    },
    component_function = {
        gitbranch = "TruncateGitBranch"
    },
}

-- FZF
vim.api.nvim_set_keymap("n", "<Leader>f", ":Files<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>b", ":Buffers<CR>", {noremap = true})

-- nvim-compe
vim.o.completeopt = "menuone,noselect"

require"compe".setup {
    enabled = true,
    autocomplete = true,
    source = {
        path = true,
        buffer = true,
        nvim_lsp = true,
    },
}

local compe_t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return compe_t "<C-n>"
    else
        return compe_t "<Tab>"
  end
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return compe_t "<C-p>"
    else
        -- If <S-Tab> is not working in your terminal, change it to <C-h>
        return compe_t "<S-Tab>"
    end
end

vim.api.nvim_set_keymap("i",
    "<Tab>", "v:lua.tab_complete()", {expr = true, noremap = true})
vim.api.nvim_set_keymap("i",
    "<S-Tab>", "v:lua.s_tab_complete()", {expr = true, noremap = true})
vim.api.nvim_set_keymap("i",
    "<C-Space>", "compe#complete()", {expr = true, noremap = true})
vim.api.nvim_set_keymap("i",
    "<C-e>", "compe#close('<C-e>')", {expr = true, noremap = true})
EOF
