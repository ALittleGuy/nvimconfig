local git = require('config.git')

return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = git.setup,
  },
  {
    'sindrets/diffview.nvim',
    lazy = false,
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose', 'DiffviewFocusFiles', 'DiffviewToggleFiles' },
    keys = {
      { '<leader>dv', '<cmd>DiffviewOpen<CR>', desc = 'Open diff view' },
      { '<leader>df', '<cmd>DiffviewFileHistory %<CR>', desc = 'File history' },
      { '<leader>dF', '<cmd>DiffviewFileHistory<CR>', desc = 'Repository history' },
      { '<leader>dc', '<cmd>DiffviewClose<CR>', desc = 'Close diff view' },
      { '<leader>do', '<cmd>DiffviewFocusFiles<CR>', desc = 'Focus diff file panel' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = git.setup_diffview,
  },
}
