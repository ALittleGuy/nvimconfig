local telescope_builtin = require('telescope.builtin')

vim.keymap.del('n', 'grn')
vim.keymap.del({ 'n', 'x' }, 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'gO')
vim.keymap.del({ 'i', 's' }, '<C-S>')

local function map(mode, lhs, rhs, desc, extra)
  local options = vim.tbl_extend('force', {
    buffer = true,
    noremap = true,
    silent = true,
    nowait = true,
    desc = desc,
  }, extra or {})
  vim.keymap.set(mode, lhs, rhs, options)
end

local function has_lsp_clients(bufnr)
  return #vim.lsp.get_clients({ bufnr = bufnr }) > 0
end

local function hover_or_keywordprg()
  if has_lsp_clients(0) then
    vim.lsp.buf.hover()
  else
    vim.cmd('!' .. vim.o.keywordprg .. ' ' .. vim.fn.expand('<cword>'))
  end
end

local function check_backspace()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

_G.config_check_backspace = check_backspace

_G.switch_source_header = function()
  local active_clients = vim.lsp.get_clients({ bufnr = 0, name = 'clangd' })
  if #active_clients == 0 then
    vim.notify('clangd 未附加到当前缓冲区', vim.log.levels.WARN)
    return
  end

  vim.lsp.buf.execute_command({
    command = 'clangd.switchSourceHeader',
    arguments = { vim.api.nvim_buf_get_name(0) },
  })
end

vim.keymap.set('n', 'K', hover_or_keywordprg, { noremap = true, silent = true, nowait = true, desc = 'Hover documentation' })
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, { noremap = true, silent = true, nowait = true, desc = 'Previous diagnostic' })
vim.keymap.set('n', ']g', vim.diagnostic.goto_next, { noremap = true, silent = true, nowait = true, desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>ch', _G.switch_source_header, { noremap = true, silent = true, nowait = true, desc = 'Switch source/header' })

vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 2,
    source = 'if_many',
  },
  float = {
    border = 'single',
    source = 'if_many',
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition', { buffer = bufnr })
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration', { buffer = bufnr })
    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation', { buffer = bufnr })
    map('n', 'gY', vim.lsp.buf.type_definition, 'Go to type definition', { buffer = bufnr })
    map('n', 'gr', vim.lsp.buf.references, 'List references', { buffer = bufnr })
    map('n', '<leader>as', vim.lsp.buf.code_action, 'Code action', { buffer = bufnr })
    map('x', '<leader>as', vim.lsp.buf.code_action, 'Range code action', { buffer = bufnr })
    map('n', '<leader>ac', vim.lsp.buf.code_action, 'Code action', { buffer = bufnr })
    map('n', '<leader>qf', function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { 'quickfix' },
          diagnostics = vim.diagnostic.get(bufnr),
        },
      })
    end, 'Quick fix', { buffer = bufnr })
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol', { buffer = bufnr })
    map('n', '<leader>cf', function()
      vim.lsp.buf.format({ async = true })
    end, 'Format buffer', { buffer = bufnr })
    map('x', '<leader>cf', function()
      vim.lsp.buf.format({ async = true })
    end, 'Format selection', { buffer = bufnr })
    map('n', '<leader>rf', vim.lsp.buf.code_action, 'Refactor', { buffer = bufnr })
    map('n', '<leader>rs', vim.lsp.buf.code_action, 'Refactor', { buffer = bufnr })
    map('x', '<leader>rs', vim.lsp.buf.code_action, 'Refactor selection', { buffer = bufnr })
    map('n', 'gs', telescope_builtin.lsp_document_symbols, 'Document symbols', { buffer = bufnr })
    map('n', 'gc', function()
      telescope_builtin.lsp_workspace_symbols({ query = vim.fn.expand('<cword>') })
    end, 'Workspace symbols', { buffer = bufnr })

    pcall(vim.lsp.completion.enable, true, client.id, bufnr, { autotrigger = true })
  end,
})

vim.lsp.config('clangd', {
  cmd = {
    '/usr/bin/clangd',
    '--background-index',
    '--clang-tidy',
    '-j=32',
    '--completion-style=detailed',
    '--cross-file-rename',
  },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  root_markers = { '.clangd', 'compile_commands.json', 'compile_flags.txt', '.git' },
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
})

vim.lsp.enable('clangd')
vim.lsp.enable('gopls')
