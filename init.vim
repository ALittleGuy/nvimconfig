"
" normal config
set ignorecase              " case insensitive
set hlsearch                " highlight search
set incsearch               " incremental search
set tabstop=2               " number of columns occupied by a tab
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=2            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=full
set cc=120                  " set an 80 column border for good coding style
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
"set clipboard=unamed
" set completeopt=menu,menuone
" set spell                 " enable spell check (may need to download language package)
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.
set foldmethod=syntax  " 对支持的语法进行折叠
set foldmethod=indent  " 根据缩进折叠
set foldmethod=marker  " 使用特定的标记来折叠


" plugin config
call plug#begin()
 Plug 'dracula/vim'
 Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
 Plug 'folke/tokyonight.nvim'
 Plug 'rakr/vim-one'
 Plug 'honza/vim-snippets'
 Plug 'folke/tokyonight.nvim'
 Plug 'nvim-tree/nvim-tree.lua'
 Plug 'nvim-tree/nvim-web-devicons'
 Plug 'vim-airline/vim-airline'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'nvim-lua/popup.nvim'
 Plug 'nvim-lua/plenary.nvim'
 Plug 'nvim-telescope/telescope.nvim', {'do': ':UpdateRemotePlugins'}
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
 Plug 'mhinz/vim-startify'        " 启动屏幕
 Plug 'jiangmiao/auto-pairs'
 Plug 'preservim/nerdcommenter'
 Plug 'akinsho/bufferline.nvim'
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
 Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
 Plug 'luochen1990/rainbow'
 Plug 'lewis6991/gitsigns.nvim'
 Plug 'sindrets/diffview.nvim'
 Plug 'liuchengxu/vista.vim'   " overview for code
 Plug 'lukas-reineke/indent-blankline.nvim' " indent line
" Plug 'ianding1/leetcode.vim' 
 Plug 'SirVer/ultisnips'
 Plug 'honza/vim-snippets'

call plug#end()

" vim vim-startify
" 设置启动屏幕标题
let g:startify_custom_header = 'startify#center(["WELCOME BACK COMMANDER"])'

" rainbow brackets1
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
\   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\   'operators': '_,_',
\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\   'separately': {
\       '*': {},
\       'tex': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\       },
\   }
\}
" 设置启动屏幕显示的最近文件数量
let g:startify_files_number = 10

" 设置书签
let g:startify_bookmarks = [
\ { 's': '~/cluster/odp' },
\ { 'k': '~/cluster/obkv/odp' },
\ { 'i': '~/.config/nvim/init.vim' },
\ { 'c': '~/.config/nvim/coc-settings.json' },
\ { 'z': '~/.zshrc' },
\ ]

" themes config
"colorscheme dracula
" colorscheme tokyonight

colorscheme catppuccin

let g:airline_theme='one'

set background=dark " for the dark version
" set background=light " for the light versio
"


" 离开insert 自动保存
augroup autosave
  autocmd!
  autocmd InsertLeave,TextChanged * if &buftype == '' | update | endif
augroup END


" keymapping config
let mapleader = " "


" nvim vista config
nnoremap <leader>gv :Vista coc<CR>
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_sidebar_position = 'vertical topleft'
let g:vista_sidebar_width = 50
" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc

"leetcode"
let g:leetcode_china=1  "中国区leetcode"
let g:leetcode_solution_filetype='python3'    
let g:leetcode_browser='chrome'   


" telescope conifg
nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fc :execute 'Telescope grep_string search=' . expand('<cword>')<CR><Esc>

" nnoremap <Leader>fs :lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>


nnoremap <leader>h ^
nnoremap <leader>l $
nnoremap <leader>b %
xmap <leader>h ^
xmap <leader>l $
xmap <leader>b %


nnoremap <leader>bn :bNext<CR>
nnoremap <leader>bp :bPrevious<CR>

" cocconfig
" nnoremap <silent> gd <Plug>(coc-definition)
" nnoremap <silent> gr <Plug>(coc-references)
" nnoremap <silent> gi <Plug>(coc-implementation)
"


" lsp-config config
" 触发代码补全的建议
" " Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" 跳转s定义
nmap <silent> gd <Plug>(coc-definition)
" 跳转到声明
nmap <silent> gD <Plug>(coc-declaration)
" 跳转到实现
nmap <silent> gi <Plug>(coc-implementation)
" 跳转到类型定义
nmap <silent> gY <Plug>(coc-type-definition)
" 查看引用
nmap <silent> gr <Plug>(coc-references)
" 查看函数/方法文档
nmap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" 使用 `coc-codeaction-selected` 来应用选中区域的代码操作
xmap <leader>as  <Plug>(coc-codeaction-selected)
nmap <leader>as  <Plug>(coc-codeaction-selected)
" 使用 `coc-codeaction` 来应用代码操作
nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)

nmap <leader>rn <Plug>(coc-rename)
nmap gs :CocList -I symbols<CR>
nmap gc :<C-u>exe 'CocList -I symbols ' . expand('<cword>')<CR>

xmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)
nmap <silent> <leader>rf <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>rs  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>rs  <Plug>(coc-codeaction-refactor-selected)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


"nvimtree
nmap <leader>nt :NvimTreeFindFileToggle <CR>



nnoremap <C-J> 4j
vnoremap <C-J> 4j
nnoremap <C-K> 4k
vnoremap <C-K> 4k


vnoremap <C-u> 9k
nnoremap <C-u> 9k
vnoremap <C-d> 9j
nnoremap <C-d> 9j


" tab auto complete config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" toggle terimnal config
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>

" By applying the mappings this way you can pass a count to your
" mapping to open a specific window.
" For example: 2<C-t> will open terminal 2
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>


" utilsnip
"

let g:UltiSnipsExpandTrigger="<Nop>"
let g:UltiSnipsJumpForwardTrigger="<Nop"
let g:UltiSnipsJumpBackwardTrigger="<Nop>"

" lua config
lua <<EOF

-- buffer line config
local status, bufferline = pcall(require, "bufferline")
if not status then
    vim.notify("没有找到 bufferline")
  return
end




bufferline.setup({
	options = {
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "left",
				separator = true,
			},
		},
	},
})


-- nvimtree config
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- empty setup using defaults
local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)
  -- custom mappings
end


-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  on_attach = my_on_attach,
  open_on_tab = false
})




-- toggle terminal config
require("toggleterm").setup{
  float_opts = {
      -- The border key is *almost* the same as 'nvim_open_win'
      -- see :h nvim_open_win for details on borders however
      -- the 'curved' border is a custom border type
      -- not natively supported but implemented in this plugin.
      border = 'single', -- other options supported by win open
      -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
  },
  size = function(term)
    if term.direction == "horizontal" then
      return 40
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
}


-- keypmap config
vim.api.nvim_set_keymap('n', '<C-j>', '4j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '4k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-j>', '4j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-k>', '4k', { noremap = true, silent = true })


-- diffview configuration
require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

-- indent line config
require("ibl").setup()


EOF
