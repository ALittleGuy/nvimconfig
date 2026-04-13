local M = {}

function M.setup()
  require('gitsigns').setup({
    signs = {
      add = { text = '│' },
      change = { text = '│' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, lhs, rhs, desc, extra)
        vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', {
          buffer = bufnr,
          silent = true,
          noremap = true,
          desc = desc,
        }, extra or {}))
      end

      map('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(gs.next_hunk)
        return '<Ignore>'
      end, 'Next hunk', { expr = true })

      map('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(gs.prev_hunk)
        return '<Ignore>'
      end, 'Previous hunk', { expr = true })

      map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
      map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
      map('v', '<leader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, 'Stage selected hunk')
      map('v', '<leader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, 'Reset selected hunk')
      map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
      map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
      map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
      map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
      map('n', '<leader>hb', function()
        gs.blame_line({ full = true })
      end, 'Blame line')
      map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle line blame')
      map('n', '<leader>hd', gs.diffthis, 'Diff this')
      map('n', '<leader>hD', function()
        gs.diffthis('~')
      end, 'Diff against previous revision')
      map('n', '<leader>td', gs.toggle_deleted, 'Toggle deleted lines')
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select hunk')
    end,
  })
end

return M
