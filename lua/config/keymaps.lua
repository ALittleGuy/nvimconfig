local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
map('n', '<leader>fc', function()
  require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })
end, opts)

map('n', '<leader>h', '^', opts)
map('n', '<leader>l', '$', opts)
map('n', '<leader>b', '%', opts)
map('x', '<leader>h', '^', opts)
map('x', '<leader>l', '$', opts)
map('x', '<leader>b', '%', opts)

map('n', '<leader>bn', '<cmd>bNext<CR>', opts)
map('n', '<leader>bp', '<cmd>bPrevious<CR>', opts)
map('n', '<leader>nt', '<cmd>NvimTreeFindFileToggle<CR>', opts)

map('n', '<C-j>', '4j', opts)
map('v', '<C-j>', '4j', opts)
map('n', '<C-k>', '4k', opts)
map('v', '<C-k>', '4k', opts)
map('n', '<C-u>', '9k', opts)
map('v', '<C-u>', '9k', opts)
map('n', '<C-d>', '9j', opts)
map('v', '<C-d>', '9j', opts)

map('n', '<C-t>', function()
  vim.cmd((vim.v.count1 or 1) .. 'ToggleTerm')
end, { noremap = true, silent = true })
map('i', '<C-t>', '<Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd('TermEnter', {
  pattern = 'term://*toggleterm#*',
  callback = function(args)
    vim.keymap.set('t', '<C-t>', function()
      vim.cmd((vim.v.count1 or 1) .. 'ToggleTerm')
    end, { buffer = args.buf, silent = true })
  end,
})
