local autosave_group = vim.api.nvim_create_augroup('autosave', { clear = true })
local autosave_enabled = true

local ignored_filetypes = {
  gitcommit = true,
  gitrebase = true,
}

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

  return vim.api.nvim_buf_get_name(bufnr) ~= ''
end

local function autosave_if_normal_buffer(args)
  if is_normal_writable_buffer(args.buf) then
    vim.cmd('silent update')
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
