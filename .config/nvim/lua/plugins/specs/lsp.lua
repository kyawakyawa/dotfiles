local config = require("config")

local M = {}

local function lsp_config()
  return config.get("features.lsp", {})
end

local function completion_trigger_characters()
  local chars = config.get("features.completion.trigger_characters", "")
  if type(chars) == "string" then
    local result = {}
    for index = 1, #chars do
      table.insert(result, chars:sub(index, index))
    end
    return result
  end
  return chars
end

local function extend_completion_triggers(client)
  local provider = client.server_capabilities.completionProvider
  if not provider then
    return
  end

  local triggers = provider.triggerCharacters or {}
  for _, char in ipairs(completion_trigger_characters()) do
    if char ~= "" and not vim.list_contains(triggers, char) then
      table.insert(triggers, char)
    end
  end
  provider.triggerCharacters = triggers
end

local function enable_completion(client, bufnr)
  if
    not client:supports_method("textDocument/completion")
    or not config.is_feature_enabled("completion")
  then
    return
  end

  extend_completion_triggers(client)
  vim.bo[bufnr].completeopt = table.concat(
    config.get("features.completion.completeopt", { "menuone", "noselect", "popup" }),
    ","
  )
  vim.lsp.completion.enable(true, client.id, bufnr, {
    autotrigger = config.get("features.completion.autotrigger", true),
  })
end

local function copilot_config()
  return config.get("features.ai.copilot", {})
end

local function is_copilot_enabled()
  return config.is_feature_enabled("ai.copilot")
end

local function enable_inline_completion(client, bufnr)
  local copilot = copilot_config()
  if
    client.name ~= "copilot"
    or not is_copilot_enabled()
    or copilot.inline_completion == false
    or not client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr)
  then
    return
  end

  vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

  vim.keymap.set("i", copilot.accept_key or "<C-f>", vim.lsp.inline_completion.get, {
    buffer = bufnr,
    desc = "Accept inline completion",
  })
  vim.keymap.set("i", copilot.previous_key or "<M-[>", function()
    vim.lsp.inline_completion.select({ count = -1 })
  end, { buffer = bufnr, desc = "Previous inline completion" })
  vim.keymap.set("i", copilot.next_key or "<M-]>", function()
    vim.lsp.inline_completion.select({ count = 1 })
  end, { buffer = bufnr, desc = "Next inline completion" })
end

function M.setup()
  local cfg = lsp_config()
  local ensure_installed = vim.deepcopy(
    cfg.ensure_installed or { "clangd", "pyright", "ruff", "jsonls", "bashls", "lua_ls", "texlab" }
  )
  if is_copilot_enabled() and not vim.list_contains(ensure_installed, "copilot") then
    table.insert(ensure_installed, "copilot")
  end

  require("mason").setup()
  require("mason-lspconfig").setup({
    automatic_enable = cfg.automatic_enable == true,
    ensure_installed = ensure_installed,
  })

  vim.api.nvim_create_user_command("PythonEnvInfo", function()
    require("python_env").print_info(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
  end, {})

  vim.api.nvim_create_user_command("PyrightClientInfo", function()
    local clients = vim.lsp.get_clients({ name = "pyright" })
    if vim.tbl_isempty(clients) then
      print("pyright client: not attached")
      return
    end

    for _, client in ipairs(clients) do
      print("pyright client id: " .. client.id)
      print("root_dir: " .. tostring(client.config.root_dir))
      print("cmd_env: " .. vim.inspect(client.config.cmd_env or {}))
      print("settings: " .. vim.inspect(client.config.settings or {}))
      print("client.settings: " .. vim.inspect(client.settings or {}))
    end
  end, {})

  vim.api.nvim_create_user_command("BufferDiagnosticsInfo", function()
    local diagnostics = vim.diagnostic.get(0)
    print("diagnostics: " .. #diagnostics)
    for _, diagnostic in ipairs(diagnostics) do
      print(
        string.format(
          "[%s] %s:%s %s",
          tostring(diagnostic.source or "unknown"),
          diagnostic.lnum + 1,
          diagnostic.col + 1,
          diagnostic.message
        )
      )
    end
  end, {})

  local on_attach = function(client, bufnr)
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gh", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "<leader>cd", function()
      vim.diagnostic.open_float({ scope = "line" })
    end, bufopts)

    local function open_diagnostic_on_jump(diagnostic, jump_bufnr)
      if diagnostic then
        vim.diagnostic.open_float({ bufnr = jump_bufnr, scope = "cursor" })
      end
    end
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, on_jump = open_diagnostic_on_jump })
    end, bufopts)
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, on_jump = open_diagnostic_on_jump })
    end, bufopts)

    if client.server_capabilities.codeLensProvider and cfg.codelens ~= false then
      vim.lsp.codelens.enable(true, { bufnr = bufnr })
    end

    if client.server_capabilities.documentHighlightProvider and cfg.document_highlight ~= false then
      local group =
        vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    enable_completion(client, bufnr)
    enable_inline_completion(client, bufnr)
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("native_lsp_completion", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        enable_completion(client, args.buf)
        enable_inline_completion(client, args.buf)
      end
    end,
  })

  vim.lsp.config("*", {
    root_markers = { ".git", ".hg" },
    on_attach = on_attach,
  })

  vim.lsp.config("clangd", {
    cmd = {
      "clangd",
      "--background-index",
      "--header-insertion=never",
      "--pch-storage=memory",
      "--clang-tidy",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "cl" },
    root_markers = { "compile_commands.json", ".cache", "compile_flags.txt" },
  })

  vim.lsp.config("pyright", {
    root_markers = { "uv.lock", "pyproject.toml", ".venv", ".git" },
    on_init = function(client)
      client.settings = vim.deepcopy(client.config.settings or {})
      client:notify("workspace/didChangeConfiguration", { settings = nil })
    end,
    before_init = function(_, server_config)
      local python_env = require("python_env")
      local settings = python_env.pyright_settings(server_config.root_dir)
      if settings then
        server_config.settings =
          vim.tbl_deep_extend("force", server_config.settings or {}, settings)
      end

      local cmd_env = python_env.pyright_cmd_env(server_config.root_dir)
      if cmd_env then
        server_config.cmd_env = vim.tbl_extend("force", server_config.cmd_env or {}, cmd_env)
      end
    end,
  })

  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        workspace = {
          library = {
            vim.env.VIMRUNTIME .. "/lua",
          },
        },
      },
    },
  })

  vim.lsp.config("copilot", {
    root_markers = { ".git" },
  })

  local diagnostics = cfg.diagnostics or {}
  local virtual_text = diagnostics.virtual_text ~= false
      and {
        format = function(diagnostic)
          return string.format(
            "%s (%s: %s)",
            diagnostic.message,
            diagnostic.source,
            diagnostic.code
          )
        end,
      }
    or false
  local signs = diagnostics.signs ~= false
      and {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
      }
    or false

  vim.diagnostic.config({
    virtual_text = virtual_text,
    signs = signs,
  })

  local enable = cfg.enable
  if enable == nil then
    enable = vim.deepcopy(ensure_installed)
  else
    enable = vim.deepcopy(enable)
  end
  if is_copilot_enabled() and not vim.list_contains(enable, "copilot") then
    table.insert(enable, "copilot")
  end
  vim.lsp.enable(enable)

  local manual_key = config.get("features.completion.manual_key", "<C-Space>")
  vim.keymap.set("i", manual_key, function()
    vim.lsp.completion.get()
  end, { desc = "LSP completion" })
end

return M
