local M = {}

local function safe_keymap_del(mode, lhs)
  pcall(vim.keymap.del, mode, lhs)
end

local function map(bufnr, mode, lhs, rhs, desc, extra)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', {
    buffer = bufnr,
    noremap = true,
    silent = true,
    nowait = true,
    desc = desc,
  }, extra or {}))
end

local function has_lsp_clients(bufnr)
  return #vim.lsp.get_clients({ bufnr = bufnr }) > 0
end

local function hover_or_keywordprg()
  if has_lsp_clients(0) then
    vim.lsp.buf.hover()
    return
  end

  vim.cmd('!' .. vim.o.keywordprg .. ' ' .. vim.fn.expand('<cword>'))
end

local function switch_source_header()
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

local function open_diagnostic_float()
  vim.diagnostic.open_float(nil, {
    border = 'single',
    focus = false,
    scope = 'line',
    source = 'if_many',
  })
end

local function lsp_attach(args)
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then
    return
  end

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  map(bufnr, 'n', 'gd', vim.lsp.buf.definition, 'Go to definition')
  map(bufnr, 'n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
  map(bufnr, 'n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
  map(bufnr, 'n', 'gY', vim.lsp.buf.type_definition, 'Go to type definition')
  map(bufnr, 'n', 'gr', vim.lsp.buf.references, 'List references')
  map(bufnr, 'n', '<leader>as', vim.lsp.buf.code_action, 'Code action')
  map(bufnr, 'x', '<leader>as', vim.lsp.buf.code_action, 'Range code action')
  map(bufnr, 'n', '<leader>ac', vim.lsp.buf.code_action, 'Code action')
  map(bufnr, 'n', '<leader>qf', function()
    vim.lsp.buf.code_action({
      apply = true,
      context = {
        only = { 'quickfix' },
        diagnostics = vim.diagnostic.get(bufnr),
      },
    })
  end, 'Quick fix')
  map(bufnr, 'n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
  map(bufnr, 'n', '<leader>cf', function()
    vim.lsp.buf.format({ async = true })
  end, 'Format buffer')
  map(bufnr, 'x', '<leader>cf', function()
    vim.lsp.buf.format({ async = true })
  end, 'Format selection')
  map(bufnr, 'n', '<leader>rf', vim.lsp.buf.code_action, 'Refactor')
  map(bufnr, 'n', '<leader>rs', vim.lsp.buf.code_action, 'Refactor')
  map(bufnr, 'x', '<leader>rs', vim.lsp.buf.code_action, 'Refactor selection')
  map(bufnr, 'n', 'gs', function()
    require('telescope.builtin').lsp_document_symbols()
  end, 'Document symbols')
  map(bufnr, 'n', 'gc', function()
    require('telescope.builtin').lsp_workspace_symbols({ query = vim.fn.expand('<cword>') })
  end, 'Workspace symbols')

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    map(bufnr, 'n', '<leader>uh', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, 'Toggle inlay hints')
  end
end

local function capabilities()
  local base = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if ok then
    return cmp_nvim_lsp.default_capabilities(base)
  end
  return base
end

local function resolve_command(candidates)
  for _, candidate in ipairs(candidates) do
    local resolved_path = vim.fn.exepath(candidate[1])
    if resolved_path ~= '' then
      local resolved = vim.deepcopy(candidate)
      resolved[1] = resolved_path
      return resolved
    end
  end
  return nil
end

local function register_server(name, config, missing_servers)
  if not config.cmd or vim.fn.executable(config.cmd[1]) ~= 1 then
    table.insert(missing_servers, name)
    return
  end

  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end

local function notify_missing_servers(missing_servers)
  if #missing_servers == 0 or #vim.api.nvim_list_uis() == 0 then
    return
  end

  vim.schedule(function()
    vim.notify('Missing LSP executables: ' .. table.concat(missing_servers, ', '), vim.log.levels.WARN)
  end)
end

local function define_diagnostic_signs()
  local signs = {
    Error = '',
    Warn = '',
    Hint = '󰠠',
    Info = '',
  }

  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
end

function M.setup_global()
  for _, lhs in ipairs({ 'grn', 'grr', 'gri', 'grt', 'gO' }) do
    safe_keymap_del('n', lhs)
  end
  safe_keymap_del({ 'n', 'x' }, 'gra')

  define_diagnostic_signs()

  vim.keymap.set('n', 'K', hover_or_keywordprg, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Hover documentation',
  })
  vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Previous diagnostic',
  })
  vim.keymap.set('n', ']g', vim.diagnostic.goto_next, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Next diagnostic',
  })
  vim.keymap.set('n', '<leader>ch', switch_source_header, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Switch source/header',
  })
  vim.keymap.set('n', '<leader>e', open_diagnostic_float, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Line diagnostics',
  })
  vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'Diagnostics to loclist',
  })

  vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    underline = true,
    signs = true,
    virtual_text = {
      spacing = 2,
      source = 'if_many',
      prefix = '●',
    },
    float = {
      border = 'single',
      source = 'if_many',
    },
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
    callback = lsp_attach,
  })
end

function M.setup_servers()
  local client_capabilities = capabilities()
  local missing_servers = {}
  local clangd_cmd = resolve_command({
    {
      '/usr/bin/clangd',
      '--background-index',
      '--clang-tidy',
      '-j=32',
      '--completion-style=detailed',
      '--cross-file-rename',
    },
    {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '-j=32',
      '--completion-style=detailed',
      '--cross-file-rename',
    },
  })
  local gopls_cmd = resolve_command({
    { 'gopls' },
  })
  local lua_ls_cmd = resolve_command({
    { 'lua-language-server' },
  })
  local pyright_cmd = resolve_command({
    { 'basedpyright-langserver', '--stdio' },
    { 'pyright-langserver', '--stdio' },
  })
  local bashls_cmd = resolve_command({
    { 'bash-language-server', 'start' },
  })

  register_server('clangd', {
    capabilities = client_capabilities,
    cmd = clangd_cmd,
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    root_markers = { '.clangd', 'compile_commands.json', 'compile_flags.txt', '.git' },
  }, missing_servers)

  register_server('gopls', {
    capabilities = client_capabilities,
    cmd = gopls_cmd,
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
  }, missing_servers)

  register_server('lua_ls', {
    capabilities = client_capabilities,
    cmd = lua_ls_cmd,
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = {
          globals = { 'vim' },
        },
        hint = {
          enable = true,
        },
        telemetry = {
          enable = false,
        },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file('', true),
        },
      },
    },
  }, missing_servers)

  register_server('pyright', {
    capabilities = client_capabilities,
    cmd = pyright_cmd,
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          typeCheckingMode = 'basic',
          useLibraryCodeForTypes = true,
        },
      },
    },
  }, missing_servers)

  register_server('bashls', {
    capabilities = client_capabilities,
    cmd = bashls_cmd,
    filetypes = { 'sh', 'bash', 'zsh' },
    root_markers = { '.git' },
  }, missing_servers)

  notify_missing_servers(missing_servers)
end

function M.setup_completion()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  local lspkind = require('lspkind')

  require('luasnip.loaders.from_vscode').lazy_load()

  local ok_autopairs, autopairs = pcall(require, 'nvim-autopairs')
  if ok_autopairs then
    autopairs.setup({
      check_ts = true,
    })
  end

  local ok_cmp_autopairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
  if ok_cmp_autopairs then
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  end

  local source_labels = {
    nvim_lsp = '[LSP]',
    luasnip = '[Snip]',
    buffer = '[Buf]',
    path = '[Path]',
    cmdline = '[Cmd]',
  }

  cmp.setup({
    preselect = cmp.PreselectMode.None,
    completion = {
      completeopt = 'menu,menuone,noinsert',
    },
    window = {
      completion = cmp.config.window.bordered({
        winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
      }),
      documentation = cmp.config.window.bordered({
        winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
      }),
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
    }, {
      { name = 'buffer' },
    }),
    experimental = {
      ghost_text = true,
    },
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = lspkind.cmp_format({
        mode = 'symbol_text',
        maxwidth = 50,
        ellipsis_char = '…',
        menu = source_labels,
      }),
    },
  })

  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }),
  })
end

return M
