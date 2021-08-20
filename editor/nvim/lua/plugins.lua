return require("packer").startup(function()
    use "itchyny/lightline.vim"
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

    -- Treesitter colors
    use {"HubertHo/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}

    -- Language syntax plugins
    use "rust-lang/rust.vim"
    use "plasticboy/vim-markdown"
end)
