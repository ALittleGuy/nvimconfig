local autosave_group = vim.api.nvim_create_augroup('autosave', { clear = true })

local function autosave_if_normal_buffer(args)
  if vim.bo[args.buf].buftype == '' then
    vim.cmd('silent update')
  end
end

vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
  group = autosave_group,
  callback = autosave_if_normal_buffer,
})
