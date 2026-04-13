vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

opt.ignorecase = true
opt.hlsearch = true
opt.incsearch = true
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.autoindent = true
opt.number = true
opt.wildmode = 'full'
opt.colorcolumn = '120'
opt.mouse = 'a'
opt.cursorline = true
opt.ttyfast = true
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.foldmethod = 'marker'
opt.background = 'dark'

vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')
