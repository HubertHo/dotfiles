-- Always set leader first
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

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
vim.opt.smarttab = true
vim.opt.softtabstop = 0
vim.opt.tabstop = 8

vim.api.nvim_command("filetype plugin on")

-------- Key Mappings and Commands --------
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

-- jump to last edit position on opening file
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
-- Ensure that the package manager is installed
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/lazy/lazy.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    local lazy_repo = "https://github.com/folke/lazy.nvim.git"
    fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazy_repo,
        install_path
    })
end
vim.opt.rtp:prepend(install_path)
require("lazy").setup({
    {"catppuccin/nvim", lazy = false, priority = 1000, name = "catppuccin"},
    {"tpope/vim-commentary"},
    {"tpope/vim-fugitive"},
    {"tpope/vim-obsession"},
    {
        "HubertHo/memo.nvim",
        config = function()
            local memo = require("memo")
            memo.setup({
                height = 60,
                width = 180,
            })
            vim.keymap.set("n", "<Leader>nt", function()
                require("memo").open_note("notes")
            end)
            vim.api.nvim_create_user_command("Memo",
                function(opts)
                    memo.open_note(opts["fargs"][1])
                end,
                {nargs = 1}
            )
        end
    },
    {
        "mhinz/vim-signify",
        config = function()
            vim.g.signify_sign_add = "++"
            vim.g.signify_sign_delete="--"
            vim.g.signify_sign_delete_first_line="--"
            vim.g.signify_sign_change="=="
        end
    },
    {
        "junegunn/fzf",
        build = ":call fzf#install()",
    },
    {
        "ibhagwan/fzf-lua",
        config = function()
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
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        name = "ibl",
        opts = {
            scope = {
                enabled = true
            }
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch="master",
        build = ":TSUpdate",
        config = function ()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "astro",
                    "bash",
                    "css",
                    "dockerfile",
                    "html",
                    "javascript",
                    "json",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "ocaml",
                    "python",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vue",
                    "yaml"
                },
                highlight = {
                    enable = true,
                },
            }
        end
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                python = {"flake8",}
            }

            -- Ruff config
            -- local parse_ruff_diagnostics = function(output, bufnr)
            -- end
            -- require("lint").linters.ruff = {
            --     cmd = "ruff",
            --     stdin = false,
            --     ignore_exitcode = true,
            -- }

            vim.g.python_indent = {
                disable_parentheses_indenting = false,
                closed_paren_align_last_line = false,
                searchpair_timeout = 150,
                continue = "shiftwidth()",
                open_paren = "shiftwidth()",
                nested_paren = "shiftwidth()",
            }
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
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
        end
    },
    {"neovim/nvim-lspconfig"},
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require"cmp"
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

            vim.keymap.set("i",
                "<Tab>", "v:lua.tab_complete()", {expr = true, noremap = true})
            vim.keymap.set("i",
                "<S-Tab>", "v:lua.s_tab_complete()", {expr = true, noremap = true})
            vim.keymap.set("i",
                "<C-Space>", "compe#complete()", {expr = true, noremap = true})
            vim.keymap.set("i",
                "<C-e>", "compe#close('<C-e>')", {expr = true, noremap = true})
        end
    },
    {"rust-lang/rust.vim", ft = {"rust"}},
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
vim.cmd("colorscheme catppuccin")

-- Diagnostics
vim.diagnostic.config({
    virtual_text = false,
    float = {
        format = function(diagnostic)
            return string.format(
                "L%s %s:%s - %s",
                diagnostic.lnum,
                diagnostic.col,
                diagnostic.end_col,
                diagnostic.message
            )
        end,
    },
    severity_sort = true,
    signs = {
        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN] = "W",
        [vim.diagnostic.severity.INFO] = "I",
        [vim.diagnostic.severity.HINT] = "H",
    },
})

local opts = { noremap=true, silent=true }
vim.keymap.set(
    "n", "<Leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts
)
vim.keymap.set(
    "n", "[e", "<Cmd>lua vim.diagnostic.goto_prev()<CR>", opts
)
vim.keymap.set(
    "n", "]e", "<Cmd>lua vim.diagnostic.goto_next()<CR>", opts
)
---------------------------------------------------------------------------------------------------
--
-- LSP Configuration
--
---------------------------------------------------------------------------------------------------
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

    vim.api.nvim_buf_set_keymap(
        bufnr, "n", "H", "<Cmd>lua vim.lsp.buf.hover()<CR>", options
    )
end

vim.lsp.config("jedi_language_server", {on_attach = on_attach})
vim.lsp.enable("jedi_language_server")

vim.lsp.config("rust_analyzer", {on_attach = on_attach})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("ts_ls", {
    on_attach = on_attach,
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        -- vue_ls requires a ts_ls client to be running at the same time
        "vue",
    },
})
vim.lsp.enable("ts_ls")

vim.lsp.config("astro", {on_attach = on_attach})
vim.lsp.enable("astro")

vim.lsp.config("vue_ls", {on_attach = on_attach})
vim.lsp.enable("vue_ls")

vim.lsp.config("ocamllsp", {
    cmd = {"ocamllsp"},
    on_attach = on_attach,
    filetypes = {
        "ocaml",
        "ocaml.interface",
        "ocaml.menhir",
        "ocaml.ocamllex",
        "dune",
        "reason",
    },
    root_markers = {
        {"dune-project", "dune-workspace"},
        {"*.opam", "esy.json", "package.json"},
        ".git",
    },
    settings = {}
})
vim.lsp.enable("ocamllsp")
