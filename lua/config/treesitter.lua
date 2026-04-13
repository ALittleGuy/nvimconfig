local M = {}

local languages = {
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
}

function M.setup()
  local ok, treesitter = pcall(require, 'nvim-treesitter')
  if not ok then
    vim.schedule(function()
      vim.notify('nvim-treesitter 尚未完成安装，下一次启动会自动生效', vim.log.levels.WARN)
    end)
    return
  end

  treesitter.setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
  })

  local install_ok, install = pcall(require, 'nvim-treesitter.install')
  if install_ok then
    install.install(languages, { summary = true })
  end

  local treesitter_group = vim.api.nvim_create_augroup('treesitter_runtime', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = treesitter_group,
    pattern = languages,
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
    end,
  })
end

return M

