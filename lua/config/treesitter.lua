local M = {}

function M.setup()
  local ok, configs = pcall(require, 'nvim-treesitter.configs')
  if not ok then
    vim.schedule(function()
      vim.notify('nvim-treesitter 尚未完成安装，下一次启动会自动生效', vim.log.levels.WARN)
    end)
    return
  end

  configs.setup({
    ensure_installed = {
      'bash',
      'c',
      'cpp',
      'go',
      'json',
      'lua',
      'markdown',
      'markdown_inline',
      'python',
      'query',
      'vim',
      'vimdoc',
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  })
end

return M
