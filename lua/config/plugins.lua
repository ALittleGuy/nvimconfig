vim.cmd([[
call plug#begin()
 Plug 'dracula/vim'
 Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
 Plug 'folke/tokyonight.nvim'
 Plug 'rakr/vim-one'
 Plug 'neovim/nvim-lspconfig'
 Plug 'nvim-tree/nvim-tree.lua'
 Plug 'nvim-tree/nvim-web-devicons'
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'nvim-lua/popup.nvim'
 Plug 'nvim-lua/plenary.nvim'
 Plug 'nvim-telescope/telescope.nvim', {'do': ':UpdateRemotePlugins'}
 Plug 'mhinz/vim-startify'
 Plug 'jiangmiao/auto-pairs'
 Plug 'preservim/nerdcommenter'
 Plug 'akinsho/bufferline.nvim'
 Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
 Plug 'luochen1990/rainbow'
 Plug 'lewis6991/gitsigns.nvim'
 Plug 'sindrets/diffview.nvim'
 Plug 'liuchengxu/vista.vim'
 Plug 'lukas-reineke/indent-blankline.nvim'
 Plug 'SirVer/ultisnips'
 Plug 'honza/vim-snippets'
 Plug 'rebelot/kanagawa.nvim'
 Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'github/copilot.vim'
call plug#end()
]])
