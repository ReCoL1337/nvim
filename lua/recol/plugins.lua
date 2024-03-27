local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.6' })
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('theprimeagen/harpoon')
Plug('mbbill/undotree')
Plug('tpope/vim-fugitive')
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

Plug('VonHeikemen/lsp-zero.nvim', {['branch'] = 'v3.x'})

vim.call('plug#end')

--vim.cmd('colorscheme catppuccin-mocha')
