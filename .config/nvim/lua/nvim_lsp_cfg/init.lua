-- lsp config

-- mason.nvim
require("mason").setup()
require("mason-lspconfig").setup {
    automatic_enable = {
        exclude = {
          -- "rust_analyzer",
          -- "ts_ls"
        }
    },
    ensure_installed = { "clangd", "pyright", "ruff" },
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>cd', function() vim.diagnostic.open_float({scope="line"}) end, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { sync = false, timeout_ms=20000  } end, bufopts)

  -- keymap setting ...
  local cap = client.server_capabilities

  -- ref https://zenn.dev/link/comments/fd67dab010b7d5
  -- ref https://github.com/haskell/haskell-language-server/issues/1148#issuecomment-887858195
  -- Only highlight if compatible with the language
  if cap.documentHighlightProvider then
    vim.cmd [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')
local lspconfig_util = require('lspconfig/util')

local use_ccls = false -- cclsを使う場合はここをtrueにする


-- if use_ccls then
--   ---- ccls
--   lspconfig['ccls'].setup {
--     on_attach = on_attach,
--     flags = {
--       debounce_text_changes = 150,
--     },
--     init_options = {
--       cache = {
--         directory = "/tmp/ccls-cache";
--       },
--     },
--     capabilities = capabilities,
--     filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
--     root_dir = function(fname)
--       return require('lspconfig/util').root_pattern('compile_commands.json', '.ccls', 'compile_flags.txt')(fname)
--         or require('lspconfig/util').path.dirname(fname)
--     end,
--   }
-- end

-- lsp config

-- shared config
vim.lsp.config('*', {
  root_markers = { '.git', '.hg' },
})
vim.lsp.config('*', {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- clangd
vim.lsp.config('clangd', {
  cmd = {
    "clangd",
    "--background-index",
    "--header-insertion=never",
    "--pch-storage=memory",
    "--clang-tidy"
  },
  filetypes =  { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'cl' },
  root_markers = { 'compile_commands.json', '.cache', 'compile_flags.txt' }
})

-- pyright
vim.lsp.config('pyright', {
  before_init = function(_, config)
    local python_base_path = require("nvim_lsp_cfg/find_python").find_python_base_dir()
    if python_base_path ~= nil then
      config.settings.python.venvPath = python_base_path
      config.settings.python.pythonPath = python_base_path .. '/bin/python'
    end
    -- local venv_path = require("nvim_lsp_cfg/venv").search_venv_path(config.root_dir)
    -- if venv_path ~= nil then
    --   -- pythonPathをvenvに設定
    --   config.settings.python.venvPath = venv_path
    --   config.settings.python.pythonPath = venv_path .. '/bin/python'
    -- end

    -- -- ワークスペースディレクトリがpoetryのプロジェクトか確認する
    -- local poetry_venv_path = require("nvim_lsp_cfg/poetry").get_poetry_venv_path(config.root_dir)
    -- if poetry_venv_path ~= nil then
    --   -- pythonPathをpoetryのvirtualenvに設定
    --   config.settings.python.venvPath = poetry_venv_path
    --   config.settings.python.pythonPath = poetry_venv_path .. '/bin/python'
    -- end
  end,
})


vim.diagnostic.config({
  -- https://eiji.page/blog/neovim-diagnostic-config/
  virtual_text = {
    format = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})
