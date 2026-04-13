local M = {}

local side_terminal

local function load_toggleterm()
  require('lazy').load({ plugins = { 'toggleterm.nvim' } })
  return require('toggleterm.terminal').Terminal
end

function M.setup_colorscheme()
  vim.opt.termguicolors = true
  vim.cmd('colorscheme kanagawa')
end

function M.setup_nvim_tree_globals()
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

function M.setup_bufferline()
  require('bufferline').setup({
    options = {
      diagnostics = 'nvim_lsp',
      always_show_bufferline = true,
      offsets = {
        {
          filetype = 'NvimTree',
          text = 'File Explorer',
          text_align = 'left',
          separator = true,
        },
        {
          filetype = 'aerial',
          text = 'Symbols',
          text_align = 'left',
          separator = true,
        },
      },
    },
  })
end

function M.setup_lualine()
  require('lualine').setup({
    options = {
      theme = 'auto',
      globalstatus = true,
      component_separators = { left = '│', right = '│' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'dashboard', 'alpha', 'starter' },
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = {
        {
          function()
            local ok, aerial = pcall(require, 'aerial')
            if not ok then
              return ''
            end
            return aerial.get_location({ sep = ' > ' })
          end,
          cond = function()
            local ok, aerial = pcall(require, 'aerial')
            return ok and aerial.is_available()
          end,
        },
        'encoding',
        'fileformat',
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  })
end

function M.setup_nvim_tree()
  local function nvim_tree_on_attach(bufnr)
    local api = require('nvim-tree.api')
    api.config.mappings.default_on_attach(bufnr)
  end

  require('nvim-tree').setup({
    sort = {
      sorter = 'case_sensitive',
    },
    view = {
      width = 32,
      preserve_window_proportions = true,
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
      root_folder_label = false,
    },
    filters = {
      dotfiles = true,
    },
    update_focused_file = {
      enable = true,
      update_root = false,
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
    },
    on_attach = nvim_tree_on_attach,
  })
end

function M.setup_toggleterm()
  require('toggleterm').setup({
    direction = 'float',
    float_opts = {
      border = 'single',
    },
    size = function(term)
      if term.direction == 'horizontal' then
        return 16
      end
      if term.direction == 'vertical' then
        return math.floor(vim.o.columns * 0.4)
      end
      return 20
    end,
  })
end

function M.toggle_side_terminal()
  local Terminal = load_toggleterm()

  if not side_terminal then
    side_terminal = Terminal:new({
      direction = 'vertical',
      hidden = true,
      close_on_exit = false,
      size = function()
        return math.max(40, math.floor(vim.o.columns / 3))
      end,
      on_open = function(term)
        vim.schedule(function()
          if term.window and vim.api.nvim_win_is_valid(term.window) then
            vim.api.nvim_set_current_win(term.window)
            vim.cmd('wincmd L')
            vim.api.nvim_win_set_width(term.window, math.max(40, math.floor(vim.o.columns / 3)))
            vim.cmd('startinsert')
          end
        end)
      end,
    })
  end

  side_terminal:toggle()
end

function M.setup_aerial()
  require('aerial').setup({
    backends = { 'lsp', 'treesitter', 'markdown', 'man' },
    layout = {
      default_direction = 'prefer_right',
      max_width = { 40, 0.3 },
      min_width = 24,
    },
    show_guides = true,
    highlight_on_hover = true,
    attach_mode = 'window',
    close_automatic_events = { 'unsupported' },
  })
end

function M.setup_indent_guides()
  require('ibl').setup({
    indent = {
      char = '▏',
    },
    scope = {
      enabled = true,
    },
  })
end

return M
