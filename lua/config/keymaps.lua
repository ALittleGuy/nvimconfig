local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local function toggle_side_terminal()
  require('config.ui').toggle_side_terminal()
end

map('n', '<leader>h', '^', opts)
map('n', '<leader>l', '$', opts)
map('n', '<leader>b', '%', opts)
map('x', '<leader>h', '^', opts)
map('x', '<leader>l', '$', opts)
map('x', '<leader>b', '%', opts)

map('n', '<leader>bn', '<cmd>bnext<CR>', opts)
map('n', '<leader>bp', '<cmd>bprevious<CR>', opts)
map('n', '<leader>nt', '<cmd>NvimTreeFindFileToggle<CR>', opts)
map('n', '<leader>ua', '<cmd>AutosaveToggle<CR>', opts)
map('n', '<leader>tv', toggle_side_terminal, vim.tbl_extend('force', opts, { desc = 'Toggle right terminal' }))
map('i', '<leader>tv', function()
  vim.cmd('stopinsert')
  toggle_side_terminal()
end, vim.tbl_extend('force', opts, { desc = 'Toggle right terminal' }))

map('n', '<C-j>', '4j', opts)
map('v', '<C-j>', '4j', opts)
map('n', '<C-k>', '4k', opts)
map('v', '<C-k>', '4k', opts)
map('n', '<C-u>', '9k', opts)
map('v', '<C-u>', '9k', opts)
map('n', '<C-d>', '9j', opts)
map('v', '<C-d>', '9j', opts)

map('n', '<C-t>', function()
  vim.cmd(vim.v.count1 .. 'ToggleTerm')
end, opts)
map('i', '<C-t>', '<Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>', opts)

vim.api.nvim_create_autocmd('TermEnter', {
  pattern = 'term://*toggleterm#*',
  callback = function(args)
    vim.keymap.set('t', '<C-t>', function()
      vim.cmd(vim.v.count1 .. 'ToggleTerm')
    end, { buffer = args.buf, silent = true })
    vim.keymap.set('t', '<leader>tv', toggle_side_terminal, {
      buffer = args.buf,
      silent = true,
      desc = 'Toggle right terminal',
    })
  end,
})
