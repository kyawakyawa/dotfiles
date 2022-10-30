local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- use Telescope.nvim -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>E', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Set capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true


-- Set up language servers

---- ccls
nvim_lsp['ccls'].setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  init_options = {
    cache = {
      directory = "/tmp/ccls-cache";
    },
  },
  capabilities = capabilities,
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_dir = function(fname)
    return util.root_pattern('compile_commands.json', '.ccls', 'compile_flags.txt')(fname)
      or util.path.dirname(fname)
  end,
}

---- clangd (OpenCL)
nvim_lsp['clangd'].setup {
  on_attach = on_attach,
  cmd = {
    "clangd",
    "--background-index",
    "--header-insertion=never",
    "--pch-storage=memory",
    "--clang-tidy"
  },
  capabilities = capabilities,
  filetypes = { 'cl' },
  root_dir = function(fname)
    return util.root_pattern('compile_commands.json', '.cache', 'compile_flags.txt')(fname)
      or util.path.dirname(fname)
  end,
}

---- cmake-language-server
nvim_lsp['cmake'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

---- efm-langserver
nvim_lsp['efm'].setup{
  on_attach = on_attach,
  filetypes = {'python'},
}

---- typescript language server
nvim_lsp['tsserver'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

-- ---- deno language server
-- nvim_lsp['denols'].setup{
--   on_attach = on_attach,
--   capabilities = capabilities,
--   root_dir = function(fname)
--     return util.root_pattern('deno.json', 'deno.jsonc')(fname)
--   end,
-- }

---- python language server
nvim_lsp['pyright'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

-- lspline.nvimを使うので廃止
-- ---- float window  diagnostic (ref https://stackoverflow.com/questions/69290794/nvim-lsp-change-lspconfig-diagnostic-message-location)
-- vim.diagnostic.config({
--   virtual_text = true
-- })
-- 
-- -- Show line diagnostics automatically in hover window
-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
