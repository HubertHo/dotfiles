return require("packer").startup(function()
    use {"junegunn/fzf", run=function() vim.fn["fzf#install"]() end}
    use "junegunn/fzf.vim"
    use "mhinz/vim-signify"
    use "tpope/vim-commentary"
    use "tpope/vim-fugitive"
    use "tpope/vim-obsession"

    -- Neovim specific plugins
    use "lukas-reineke/indent-blankline.nvim"
    use "neovim/nvim-lspconfig"
    use "hrsh7th/nvim-compe"
    use {"nvim-treesitter/nvim-treesitter", run=":TSUpdate"}
    use 'wbthomason/packer.nvim'
    use 'mfussenegger/nvim-lint'
    use 'nvim-lualine/lualine.nvim'

    -- Treesitter colors
    use "ellisonleao/gruvbox.nvim"

    -- Language syntax plugins
    use "rust-lang/rust.vim"
end)
