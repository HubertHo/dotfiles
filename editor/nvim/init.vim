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
    italic = true,
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
lspconfig.tsserver.setup{
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

lua << EOF
-------- Key Mappings and Commands --------
-- Map ; as :
vim.api.nvim_set_keymap("n", ";", ":", {noremap = true})

-- Stop accidentally opening help
vim.api.nvim_set_keymap("", "<F1>", "<Esc>", {})
vim.api.nvim_set_keymap("i", "<F1>", "<Esc>", {})

-- Save and quit
vim.api.nvim_set_keymap("n", "<Leader>w", ":w<CR>", {})
vim.api.nvim_set_keymap("n", "<Leader>q", ":q!<CR>", {})

-- Move cursor between each "line" for a wrapped line
vim.api.nvim_set_keymap("n", "j", "gj", {noremap = true})
vim.api.nvim_set_keymap("n", "k", "gk", {noremap = true})

-- Fast capitalization
vim.api.nvim_set_keymap("i", "<c-u>", "<esc>bveU<esc>Ea", {noremap = true})

-- No arrow keys
vim.api.nvim_set_keymap("n", "<up>", "<nop>", {noremap = true})
vim.api.nvim_set_keymap("n", "<down>", "<nop>", {noremap = true})
vim.api.nvim_set_keymap("i", "<up>", "<nop>", {noremap = true})
vim.api.nvim_set_keymap("i", "<down>", "<nop>", {noremap = true})
vim.api.nvim_set_keymap("i", "<left>", "<nop>", {noremap = true})
vim.api.nvim_set_keymap("i", "<right>", "<nop>", {noremap = true})

-- Use left and right arrow keys to switch between buffers
vim.api.nvim_set_keymap("n", "<left>", ":bp<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<right>", ":bn<CR>", {noremap = true})

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

-------- Plugin Configuration --------
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
local set_fzf_keymaps = function(keymap)
    local keymap_options = {noremap = true, silent = true}
    local keymap_template = "<Leader>%s"
    local command_template = "<Cmd>lua require('fzf-lua').%s()<CR>"
    for shortcut, command in pairs(keymap) do
        local mapping_str = string.format(keymap_template, shortcut)
        local command_str = string.format(command_template, command)
        vim.api.nvim_set_keymap("n", mapping_str, command_str, keymap_options)
    end
end
set_fzf_keymaps({
    s = "grep_project",
    b = "buffers",
    f = "files",
    g = "git_files",
})

-- nvim-compe
vim.o.completeopt = "menuone,noselect"

require("compe").setup {
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
