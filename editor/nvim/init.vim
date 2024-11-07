lua <<EOF
-- Ensure that packer is installed
local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        "git", "clone", "https://github.com/wbthomason/packer.nvim",
        install_path
    })
    vim.api.nvim_command "packadd packer.nvim"
end
require("plugins")

-- Colorscheme
local color_term_values = {"-256color", "alacritty"}
for _, term_value in ipairs(color_term_values) do
    if vim.endswith(vim.env.TERM, term_value) then
        vim.opt.termguicolors = true
    end
end
vim.cmd("syntax on")
vim.opt.background = "dark"
require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,
    contrast = "hard",
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")

-- nvim-treesitter
require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "latex",
        "lua",
        "markdown",
        "python",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml"
    },
    highlight = {
        enable = true,
    },
}

-- nvim-cmp
local cmp = require"cmp"
cmp.setup({
    snippet={
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = {
        {name = "nvim_lsp"},
        {name = "luasnip"},
        {name = "buffer"},
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
})

-- lspconfig
local lspconfig = require("lspconfig")

local on_attach  = function(client, bufnr)
    local options = {
        noremap = true,
        silent = true,
    }
    vim.api.nvim_buf_set_keymap(
        bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.definition()<CR>", options
    )
    vim.api.nvim_buf_set_keymap(
        bufnr, "n", "H", "<Cmd>lua vim.lsp.buf.hover()<CR>", options
    )
    -- TODO: This is broken, not sure why
    vim.api.nvim_buf_set_keymap(
        bufnr, "n", "gS", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", options
    )
end

lspconfig.jedi_language_server.setup{
    on_attach = on_attach,
    root_dir = function(fname)
        local found_path = lspconfig.util.root_pattern(
            "pyproject.toml", ".git"
        )(fname)
        return found_path or vim.fn.getcwd()
    end
}
lspconfig.rust_analyzer.setup{
    on_attach = on_attach,
}
lspconfig.ts_ls.setup{
    on_attach = on_attach,
}
lspconfig.ccls.setup{
    on_attach = on_attach,
}

-- Linter Config
require("lint").linters_by_ft = {
    python = {"flake8",}
}
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


lua << EOF
-- Diagnostics
function format_float_diagnostic_message(diagnostic)
    return string.format(
        "L%s %s:%s - %s",
        diagnostic.lnum,
        diagnostic.col,
        diagnostic.end_col,
        diagnostic.message
    )
end

vim.diagnostic.config({
    virtual_text = false,
    float = {
        format = format_float_diagnostic_message,
    },
    severity_sort = true,
})

vim.fn.sign_define("DiagnosticSignError", {
    text=" E",
    texthl="DiagnosticSignError",
    linehl = "",
    numhl = ""
})
vim.fn.sign_define("DiagnosticSignWarn", {
    text=" W",
    texthl="DiagnosticSignWarn",
    linehl = "",
    numhl = ""
})
vim.fn.sign_define("DiagnosticSignInfo", {
    text=" I",
    texthl="DiagnosticSignInfo",
    linehl = "",
    numhl = ""
})
vim.fn.sign_define("DiagnosticSignHint", {
    text=" H",
    texthl="DiagnosticSignHint",
    linehl = "",
    numhl = ""
})

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap(
    'n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts
)
vim.api.nvim_set_keymap(
    'n', '[e', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts
)
vim.api.nvim_set_keymap(
    'n', ']e', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts
)
EOF

"-------- Plugin Configuration --------
lua <<EOF
-- vim-signify
vim.g.signify_sign_add = "++"
vim.g.signify_sign_delete="--"
vim.g.signify_sign_delete_first_line="--"
vim.g.signify_sign_change="=="

-- lualine
local filenameConfig = {
    "filename",
    file_status = true,
    newfile_status = true,
    path = 0,
}
local truncateBranchName = function(str)
    local branchNameLengthLimit = 40
    local branchName = str
    if (string.len(branchName) > branchNameLengthLimit) then
        branchName = string.sub(branchName, 0, branchNameLengthLimit) .. "..."
    end
    return branchName
end

require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = {left = "|", right = "|"},
        section_separators = '',
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {
            {
                'branch',
                icons_enabled = false,
                fmt = truncateBranchName,
            },
            'diff',
            'diagnostics'
        },
        lualine_c = {filenameConfig},
        lualine_x = {'encoding', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {filenameConfig},
        lualine_x = {'progress'},
        lualine_y = {'location'},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            {"tabs", mode = 2}
        },
    },
}

-- FZF
vim.api.nvim_set_keymap("n", "<Leader>g", "<Cmd>GFiles<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>f", "<Cmd>Files<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>b", "<Cmd>Buffers<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>s", "<Cmd>Rg<CR>", {noremap = true})
EOF
