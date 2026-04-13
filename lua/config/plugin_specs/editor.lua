local treesitter = require('config.treesitter')

return {
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    config = function()
      require('Comment').setup({
        toggler = {
          line = '<leader>/',
        },
        opleader = {
          line = '<leader>/',
        },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = treesitter.setup,
  },
}
