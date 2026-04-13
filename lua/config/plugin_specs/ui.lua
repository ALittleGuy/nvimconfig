local ui = require('config.ui')

return {
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    config = ui.setup_colorscheme,
  },
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'folke/tokyonight.nvim' },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = ui.setup_bufferline,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = ui.setup_lualine,
  },
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFileToggle', 'NvimTreeFocus' },
    init = ui.setup_nvim_tree_globals,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = ui.setup_nvim_tree,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    cmd = 'ToggleTerm',
    keys = { '<C-t>' },
    config = ui.setup_toggleterm,
  },
  {
    'stevearc/aerial.nvim',
    cmd = { 'AerialOpen', 'AerialToggle' },
    keys = {
      { '<leader>gv', '<cmd>AerialToggle!<CR>', desc = 'Toggle symbol outline' },
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
    },
    config = ui.setup_aerial,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'VeryLazy',
    config = ui.setup_indent_guides,
  },
}
