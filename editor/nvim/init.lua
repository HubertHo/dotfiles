-- Always set leader first
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
---------------------------------------------------------------------------------------------------
--
-- Options
--
---------------------------------------------------------------------------------------------------
-- Automatically apply changes if the file changes outside of neovim
vim.opt.autoread = true
vim.opt.colorcolumn = "101"
vim.opt.conceallevel = 0
vim.opt.encoding = "utf8"
vim.opt.formatoptions:append({t = true, c = true, r = true})
vim.opt.guicursor = ""
vim.opt.hidden = true
vim.opt.laststatus = 2
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.scl = "yes"
vim.opt.shortmess:append("c")

-- Show matching parentheses
vim.opt.showmatch = true
vim.opt.showtabline = 2

-- Reduce update time to show git diffs
vim.opt.updatetime = 100
vim.opt.visualbell = true

-- Splits that make sense
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Search configuration
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tabbing
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = false
vim.opt.softtabstop = 0
vim.opt.tabstop = 8

vim.api.nvim_command("filetype plugin on")

---------------------------------------------------------------------------------------------------
--
-- Key Mappings
--
---------------------------------------------------------------------------------------------------
-- Map ; as :
vim.keymap.set("n", ";", ":", {noremap = true})

-- Stop accidentally opening help
vim.keymap.set("", "<F1>", "<Esc>", {})
vim.keymap.set("i", "<F1>", "<Esc>", {})

-- Save and quit
vim.keymap.set("n", "<Leader>w", ":w<CR>", {})
vim.keymap.set("n", "<Leader>q", ":q!<CR>", {})

-- Move cursor between each "line" for a wrapped line
vim.keymap.set("n", "j", "gj", {noremap = true})
vim.keymap.set("n", "k", "gk", {noremap = true})

-- Move up/down half page but also center the view
vim.keymap.set("n", "<c-u>", "<c-u>zz", {noremap = true})
vim.keymap.set("n", "<c-d>", "<c-d>zz", {noremap = true})

-- Fast capitalization
vim.keymap.set("i", "<c-u>", "<esc>bveU<esc>Ea", {noremap = true})

-- No arrow keys
vim.keymap.set("n", "<up>", "<nop>", {noremap = true})
vim.keymap.set("n", "<down>", "<nop>", {noremap = true})
vim.keymap.set("i", "<up>", "<nop>", {noremap = true})
vim.keymap.set("i", "<down>", "<nop>", {noremap = true})
vim.keymap.set("i", "<left>", "<nop>", {noremap = true})
vim.keymap.set("i", "<right>", "<nop>", {noremap = true})

-- Use left and right arrow keys to switch between buffers
vim.keymap.set("n", "<left>", ":bp<CR>", {noremap = true})
vim.keymap.set("n", "<right>", ":bn<CR>", {noremap = true})
---------------------------------------------------------------------------------------------------
--
-- Autocommands
--
---------------------------------------------------------------------------------------------------
-- Jump to last edit position on opening file
vim.api.nvim_create_autocmd(
    'BufReadPost',
    {
        pattern = '*',
        callback = function(ev)
            if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
                -- except for in git commit messages
                -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
                if not vim.fn.expand('%:p'):find('.git', 1, true) then
                    vim.cmd('exe "normal! g\'\\""')
                end
            end
        end
    }
)
---------------------------------------------------------------------------------------------------
--
-- Plugin Configuration
--
---------------------------------------------------------------------------------------------------

local post_install_hooks = function(event)
    local name, event = event.data.spec.name, event.data.kind
    if name == "fzf" and (kind == "update" or kind == "install") then
        vim.cmd("call fzf#install()")
    elseif name == "nvim-treesitter" and kind == "update" then
        vim.cmd("TSUpdate")
    end
end
vim.api.nvim_create_autocmd("PackChanged", {callback = post_install_hooks})

vim.pack.add({
    {src = "https://github.com/zenbones-theme/zenbones.nvim", name = "zenbones"},
    {src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main"},
    "https://github.com/rktjmp/lush.nvim",
    "https://github.com/tpope/vim-commentary",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/tpope/vim-obsession",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/junegunn/fzf",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/mfussenegger/nvim-lint",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/saadparwaiz1/cmp_luasnip",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/hrsh7th/nvim-cmp",
})

-- gitsigns
require("gitsigns").setup({
    signs = {
        add          = { text = ' ┃' },
        change       = { text = ' ┃' },
        delete       = { text = ' _' },
        topdelete    = { text = ' ‾' },
        changedelete = { text = ' ~' },
        untracked    = { text = ' ┆' },
    },
    signs_staged_enable = false,
    on_attach = function(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
            else
                gitsigns.nav_hunk('next')
            end
        end)

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({'[c', bang = true})
            else
                gitsigns.nav_hunk('prev')
            end
        end)
    end
})

--fzf-lua
local set_fzf_keymaps = function(keymap)
    local keymap_options = {noremap = true, silent = true}
    local keymap_template = "<Leader>%s"
    local command_template = "<Cmd>lua require('fzf-lua').%s()<CR>"
    for shortcut, command in pairs(keymap) do
        local mapping_str = string.format(keymap_template, shortcut)
        local command_str = string.format(command_template, command)
        vim.keymap.set("n", mapping_str, command_str, keymap_options)
    end
end
set_fzf_keymaps({
    s = "grep_project",
    b = "buffers",
    f = "files",
    g = "git_files",
})

local fzf_lua = require("fzf-lua")
local fzf_actions = fzf_lua.actions
fzf_lua.setup({
    actions = {
        files = {
            ["default"] = fzf_actions.file_edit_or_qf,
            ["ctrl-h"] = fzf_actions.file_split,
            ["ctrl-v"] = fzf_actions.file_vsplit,
            ["ctrl-s"] = fzf_actions.file_tabedit,
            ["alt-q"] = fzf_actions.file_sel_to_qf,
            ["alt-l"] = fzf_actions.file_sel_to_ll,
        },
        buffers = {
            ["default"] = fzf_actions.buf_edit,
            ["ctrl-h"] = fzf_actions.buf_split,
            ["ctrl-v"] = fzf_actions.buf_vsplit,
            ["ctrl-s"] = fzf_actions.buf_tabedit,
        }
    }
})

-- indent-blankline
require("ibl").setup({
    scope = {
        enabled = true,
    }
})

-- nvim-lint
require("lint").linters_by_ft = {
    python = {"flake8",}
}
vim.g.python_indent = {
    disable_parentheses_indenting = false,
    closed_paren_align_last_line = false,
    searchpair_timeout = 150,
    continue = "shiftwidth()",
    open_paren = "shiftwidth()",
    nested_paren = "shiftwidth()",
}

-- nvim-cmp
local cmp = require("cmp")
cmp.setup({
    snippet = {
      expand = function(args)
          require('luasnip').lsp_expand(args.body)
      end,
    },
    sources = {
        {name = "nvim_lsp", group_index = 1},
        {name = "buffers", group_index = 2},
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping.select_next_item(
            {
                behavior = cmp.SelectBehavior.Insert,
                count = 1
            }
        ),
        ["<S-Tab>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Insert,
            count = 1,
        }),
    }),
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()

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

vim.keymap.set("i", "<Tab>", "v:lua.tab_complete()", {expr = true, noremap = true})
vim.keymap.set("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true, noremap = true})
vim.keymap.set("i", "<C-Space>", "compe#complete()", {expr = true, noremap = true})
vim.keymap.set("i", "<C-e>", "compe#close('<C-e>')", {expr = true, noremap = true})

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

require('lualine').setup({
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
})

-- nvim-treesitter
require('nvim-treesitter').install({
    "astro",
    "bash",
    "css",
    "dockerfile",
    "haskell",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml"
}):wait(1000 * 60 * 5)
vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        "astro",
        "bash",
        "css",
        "dockerfile",
        "haskell",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "lua",
        "markdown",
        "python",
        "toml",
        "typescript",
        "typescriptreact",
        "vim",
        "yaml"
    },
    callback = function() vim.treesitter.start() end,
})
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach  = function(client, bufnr)
    local options = {
        noremap = true,
        silent = true,
    }
    vim.api.nvim_buf_set_keymap(
        bufnr, "n", "gD", "<C-w>v<Cmd>lua vim.lsp.buf.definition()<CR>", options
    )
    -- TODO: This is broken, not sure why
    vim.api.nvim_buf_set_keymap(
        bufnr, "n", "gS", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", options
    )

    vim.api.nvim_buf_set_keymap(
        bufnr, "n", "H", "<Cmd>lua vim.lsp.buf.hover()<CR>", options
    )
end

vim.lsp.enable("jedi_language_server")
vim.lsp.config("jedi_language_server", {
    capabilities = capabilities,
    on_attach = on_attach,
    root_dir = function(fname)
        local found_path = lspconfig.util.root_pattern(
            "pyproject.toml", ".git"
        )(fname)
        return found_path or vim.fn.getcwd()
    end
})
vim.lsp.enable("rust_analyzer")
vim.lsp.config("rust_analyzer", {
    capabilities = capabilities,
    on_attach = on_attach
})
vim.lsp.enable("ts_ls")
vim.lsp.config("ts_ls", {
    capabilities = capabilities,
    on_attach = on_attach
})
vim.lsp.enable("astro")
vim.lsp.config("astro", {
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
        typescript = {
            tsdk = "/usr/lib/node_modules/typescript/lib",
        }
    }
})
      
-- Colorscheme
local color_term_values = {"-256color", "alacritty"}
for _, term_value in ipairs(color_term_values) do
    if vim.endswith(vim.env.TERM, term_value) then
        vim.opt.termguicolors = true
    end
end
vim.cmd("syntax on")
vim.opt.background = "light"
vim.cmd("colorscheme seoulbones")

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
vim.keymap.set(
    'n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts
)
vim.keymap.set(
    'n', '[e', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts
)
vim.keymap.set(
    'n', ']e', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts
)
