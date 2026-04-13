vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.autoindent = true
opt.smartindent = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.splitright = true
opt.splitbelow = true
opt.wildmode = 'full'
opt.colorcolumn = '120'
opt.mouse = 'a'
opt.cursorline = true
opt.updatetime = 200
opt.timeoutlen = 400
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.background = 'dark'
opt.termguicolors = true

