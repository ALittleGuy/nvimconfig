vim.g.startify_custom_header = 'startify#center(["WELCOME BACK COMMANDER"])'
vim.g.startify_files_number = 10
vim.g.startify_bookmarks = {
  { ['s'] = '~/cluster/odp' },
  { ['k'] = '~/cluster/obkv/odp' },
  { ['i'] = '~/.config/nvim/init.vim' },
  { ['z'] = '~/.zshrc' },
}

vim.g.rainbow_active = 1
vim.g.rainbow_conf = {
  guifgs = { 'royalblue3', 'darkorange3', 'seagreen3', 'firebrick' },
  ctermfgs = { 'lightblue', 'lightyellow', 'lightcyan', 'lightmagenta' },
  operators = '_,_',
  parentheses = {
    'start=/(/ end=/)/ fold',
    'start=/\\[/ end=/\\]/ fold',
    'start=/{/ end=/}/ fold',
  },
  separately = {
    ['*'] = {},
    tex = {
      parentheses = {
        'start=/(/ end=/)/',
        'start=/\\[/ end=/\\]/',
      },
    },
  },
}

vim.g.leetcode_china = 1
vim.g.leetcode_solution_filetype = 'python3'
vim.g.leetcode_browser = 'chrome'

vim.cmd('colorscheme kanagawa')
vim.g.airline_theme = 'one'

vim.o.statusline = vim.o.statusline .. [[%{get(b:,"vista_nearest_method_or_function","")}]]
vim.g.vista_icon_indent = { '╰─▸ ', '├─▸ ' }
vim.g.vista_sidebar_position = 'vertical topleft'
vim.g.vista_sidebar_width = 50
vim.g.vista_default_executive = 'nvim_lsp'

vim.keymap.set('n', '<leader>gv', '<cmd>Vista nvim_lsp<CR>', { noremap = true, silent = true })

local ok_bufferline, bufferline = pcall(require, 'bufferline')
if ok_bufferline then
  bufferline.setup({
    options = {
      offsets = {
        {
          filetype = 'NvimTree',
          text = 'File Explorer',
          text_align = 'left',
          separator = true,
        },
      },
    },
  })
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

local function nvim_tree_on_attach(bufnr)
  local api = require('nvim-tree.api')
  api.config.mappings.default_on_attach(bufnr)
end

require('nvim-tree').setup({
  sort = { sorter = 'case_sensitive' },
  view = { width = 30 },
  renderer = { group_empty = true },
  filters = { dotfiles = true },
  on_attach = nvim_tree_on_attach,
  open_on_tab = false,
})

require('toggleterm').setup({
  float_opts = {
    border = 'single',
  },
  size = function(term)
    if term.direction == 'horizontal' then
      return 40
    elseif term.direction == 'vertical' then
      return vim.o.columns * 0.4
    end
  end,
})

vim.g.AutoPairsMapCR = 0
vim.g.AutoPairsMapBS = 1
vim.g.AutoPairsShortcutToggle = ''
vim.g.AutoPairsShortcutFastWrap = ''
vim.g.AutoPairsShortcutJump = ''

vim.cmd([[
  inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<Plug>AutoPairsReturn"
  inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : (v:lua.config_check_backspace() ? "\<Tab>" : "\<C-x>\<C-o>")
  inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"
  inoremap <silent><expr> <C-Space> pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>"
]])

require('ibl').setup()
