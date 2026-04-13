require('nvim-treesitter.configs').setup({
  ensure_installed = { 'go' },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})
