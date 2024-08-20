-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.6',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Themes
    use { 'rose-pine/neovim', as = 'rose-pine' }
    use { 'ellisonleao/gruvbox.nvim', as = 'gruvbox' }
    -- use { 'gruvbox-community/gruvbox', as = 'gruvbox' }
    use { 'savq/melange-nvim' }
    use { 'Shatur/neovim-ayu' }

    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use ('theprimeagen/harpoon')
    use ('mbbill/undotree')
    use ('tpope/vim-fugitive')
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment the two plugins below if you want to manage the language servers from neovim
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            {'neovim/nvim-lspconfig'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
    }

    use { 'Raimondi/delimitMate', event = "InsertEnter" }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use 'lukas-reineke/indent-blankline.nvim'
    use 'numToStr/Comment.nvim'
    use 'nvim-tree/nvim-web-devicons'

    use {
        'romgrk/barbar.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
end)
