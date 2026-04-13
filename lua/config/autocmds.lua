local autosave_group = vim.api.nvim_create_augroup('autosave', { clear = true })
local startup_group = vim.api.nvim_create_augroup('startup-ui', { clear = true })
local autosave_enabled = true

local ignored_filetypes = {
  gitcommit = true,
  gitrebase = true,
}

local function is_real_file_buffer(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' or name:match('^%w+://') then
    return false
  end

  local parent = vim.fn.fnamemodify(name, ':h')
  return parent ~= '' and vim.fn.isdirectory(parent) == 1
end

local function is_normal_writable_buffer(bufnr)
  local bo = vim.bo[bufnr]
  if not autosave_enabled then
    return false
  end

  if bo.buftype ~= '' or bo.readonly or not bo.modifiable then
    return false
  end

  if ignored_filetypes[bo.filetype] then
    return false
  end

  return is_real_file_buffer(bufnr)
end

local function autosave_if_normal_buffer(args)
  if is_normal_writable_buffer(args.buf) then
    vim.cmd('silent update')
  end
end

local function startup_target_dir()
  if vim.fn.argc() == 0 then
    return vim.fn.getcwd()
  end

  local first_arg = vim.fn.argv(0)
  if first_arg == '' then
    return nil
  end

  local target = vim.fn.fnamemodify(first_arg, ':p')
  if vim.fn.isdirectory(target) == 1 then
    return target
  end

  return nil
end

local function open_startup_sidebar()
  require('lazy').load({ plugins = { 'nvim-tree.lua' } })

  local target_dir = startup_target_dir()
  if target_dir then
    vim.cmd('NvimTreeOpen ' .. vim.fn.fnameescape(target_dir))
  else
    vim.cmd('NvimTreeFindFile')
  end
end

vim.api.nvim_create_user_command('AutosaveToggle', function()
  autosave_enabled = not autosave_enabled
  vim.notify(('Autosave %s'):format(autosave_enabled and 'enabled' or 'disabled'))
end, { desc = 'Toggle autosave' })

vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufLeave', 'FocusLost' }, {
  group = autosave_group,
  callback = autosave_if_normal_buffer,
})

vim.api.nvim_create_autocmd('VimEnter', {
  group = startup_group,
  once = true,
  callback = function()
    if #vim.api.nvim_list_uis() == 0 then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].buftype ~= '' then
      return
    end

    vim.schedule(open_startup_sidebar)
  end,
})
