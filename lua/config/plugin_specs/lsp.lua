local lsp = require('config.lsp')

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    init = lsp.setup_global,
    config = lsp.setup_servers,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = lsp.setup_completion,
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind.nvim',
      'windwp/nvim-autopairs',
    },
  },
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {
      focus = false,
      use_diagnostic_signs = true,
    },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Workspace diagnostics' },
      { '<leader>xw', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer diagnostics' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<CR>', desc = 'Quickfix diagnostics' },
      { '<leader>xl', '<cmd>Trouble loclist toggle<CR>', desc = 'Location list diagnostics' },
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
}
