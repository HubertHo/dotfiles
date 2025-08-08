return require("packer").startup(function()
    use {"junegunn/fzf", run=function() vim.fn["fzf#install"]() end}
    use "mhinz/vim-signify"
    use "tpope/vim-commentary"
    use "tpope/vim-fugitive"
    use "tpope/vim-obsession"

    -- Neovim specific plugins
    use "lukas-reineke/indent-blankline.nvim"
    use "neovim/nvim-lspconfig"
    use {"nvim-treesitter/nvim-treesitter", run=":TSUpdate"}
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/nvim-cmp"
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"
    use "wbthomason/packer.nvim"
    use "mfussenegger/nvim-lint"
    use "nvim-lualine/lualine.nvim"
    use "ibhagwan/fzf-lua"

    -- Treesitter colors
    use {"catppuccin/nvim", as = "catppuccin"}

    -- Language syntax plugins
    use "rust-lang/rust.vim"
end)
