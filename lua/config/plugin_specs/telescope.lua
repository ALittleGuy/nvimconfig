return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      {
        'ahmedkhalf/project.nvim',
        config = function()
          require('project_nvim').setup({
            manual_mode = false,
            detection_methods = { 'lsp', 'pattern' },
            patterns = { '.git', 'lua' },
            show_hidden = true,
            silent_chdir = true,
          })
        end,
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
    },
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<CR>', desc = 'Find files' },
      { '<leader>fg', '<cmd>Telescope live_grep<CR>', desc = 'Live grep' },
      { '<leader>fb', '<cmd>Telescope buffers<CR>', desc = 'List buffers' },
      { '<leader>fh', '<cmd>Telescope help_tags<CR>', desc = 'Help tags' },
      { '<leader>fo', '<cmd>Telescope oldfiles<CR>', desc = 'Recent files' },
      {
        '<leader>fp',
        function()
          require('telescope').extensions.projects.projects()
        end,
        desc = 'Projects',
      },
      {
        '<leader>fc',
        function()
          require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })
        end,
        desc = 'Search current word',
      },
    },
    config = function()
      local actions = require('telescope.actions')
      local telescope = require('telescope')

      telescope.setup({
        defaults = {
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
          },
          file_ignore_patterns = {
            '%.git/',
            'node_modules/',
            '%.cache/',
          },
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          oldfiles = {
            cwd_only = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
          projects = {
            theme = 'dropdown',
            order_by = 'asc',
            hidden_files = true,
          },
        },
      })

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'projects')
    end,
  },
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },
}
