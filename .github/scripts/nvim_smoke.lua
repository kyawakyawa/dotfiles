local scenario = vim.env.NVIM_SMOKE_SCENARIO or "default"

local function fail(message)
  error(message, 0)
end

local function assert_true(value, message)
  if not value then
    fail(message)
  end
end

local function assert_false(value, message)
  if value then
    fail(message)
  end
end

local function command_exists(name)
  return vim.fn.exists(":" .. name) == 2
end

local function active_plugins()
  local active = {}
  for _, plugin in ipairs(vim.pack.get()) do
    active[plugin.spec.name] = plugin.active == true
  end
  return active
end

local function assert_active(plugin)
  assert_true(active_plugins()[plugin], "expected active plugin: " .. plugin)
end

local function assert_inactive(plugin)
  assert_false(active_plugins()[plugin], "expected inactive plugin: " .. plugin)
end

local function assert_map(mode, lhs)
  assert_true(vim.fn.maparg(lhs, mode) ~= "", "expected " .. mode .. " map: " .. lhs)
end

local function assert_no_map(mode, lhs)
  assert_true(vim.fn.maparg(lhs, mode) == "", "expected no " .. mode .. " map: " .. lhs)
end

local function assert_core()
  assert_true(vim.fn.has("nvim-0.12") == 1, "Neovim 0.12 is required")
  assert_true(type(vim.pack) == "table", "vim.pack must exist")
  assert_true(vim.lsp.config ~= nil, "vim.lsp.config must exist")
  assert_true(type(vim.treesitter.start) == "function", "vim.treesitter.start must exist")

  assert_true(command_exists("ConfigInfo"), "ConfigInfo command should exist")
  assert_true(
    command_exists("TreesitterInstallConfigured"),
    "TreesitterInstallConfigured should exist"
  )
  assert_true(command_exists("TreesitterBufferInfo"), "TreesitterBufferInfo should exist")
  assert_true(command_exists("PythonEnvInfo"), "PythonEnvInfo should exist")
  assert_true(command_exists("PyrightClientInfo"), "PyrightClientInfo should exist")
  assert_true(command_exists("BufferDiagnosticsInfo"), "BufferDiagnosticsInfo should exist")

  assert_true(
    vim.o.completeopt == "menuone,noinsert,popup",
    "completeopt should enable native popup completion"
  )
  assert_true(vim.o.winborder == "rounded", "winborder should be rounded")
  local has_pumborder, pumborder = pcall(function()
    return vim.o.pumborder
  end)
  assert_true(not has_pumborder or pumborder == "rounded", "pumborder should be rounded")
  assert_true(vim.o.pumblend == 8, "pumblend should make completion popup slightly transparent")

  assert_active("telescope.nvim")
  assert_active("yazi.nvim")
  assert_active("toggleterm.nvim")
  assert_active("conform.nvim")
  assert_active("autoclose.nvim")
  assert_active("tree-sitter-manager.nvim")
  assert_active("nvim-treesitter-textobjects")

  assert_map("n", "<leader>z")
  assert_map("n", "<leader>cx")
  assert_map("n", "<space>f")
  assert_no_map("n", "<leader>gm")
end

local function install_parser(lang)
  local installer = require("tree-sitter-manager.installer")
  installer.install({ lang }, function() end)

  local ok = vim.wait(120000, function()
    local status = installer.status[lang]
    return status ~= nil and installer.installing[lang] ~= true
  end, 250)

  assert_true(ok, "timed out installing parser: " .. lang)
  local status = installer.status[lang]
  assert_true(
    status and status.ok,
    "failed installing parser " .. lang .. ": " .. tostring(status and status.error)
  )

  local parser_path = require("tree-sitter-manager.util").ppath(lang)
  assert_true(vim.uv.fs_stat(parser_path) ~= nil, "parser file should exist: " .. parser_path)
  vim.treesitter.language.add(lang, { path = parser_path })
end

local function assert_python_treesitter()
  install_parser("python")

  local path = vim.fn.tempname() .. ".py"
  vim.fn.writefile({
    "import pathlib",
    "",
    "def hello(name: str) -> str:",
    "    return f'hello {name}'",
  }, path)
  vim.cmd.edit(vim.fn.fnameescape(path))

  local ok, err = pcall(vim.treesitter.start, 0)
  assert_true(ok, "vim.treesitter.start failed: " .. tostring(err))

  local parser_ok, parser = pcall(vim.treesitter.get_parser, 0, "python")
  assert_true(parser_ok and parser ~= nil, "python parser should be available")

  local parse_ok, trees = pcall(function()
    return parser:parse()
  end)
  assert_true(parse_ok and trees and #trees > 0, "python parser should parse a buffer")

  for _, query_name in ipairs({ "highlights", "locals", "injections", "textobjects" }) do
    local query_ok, query = pcall(vim.treesitter.query.get, "python", query_name)
    assert_true(query_ok and query ~= nil, "python query should load: " .. query_name)
  end

  local move_ok, move_err = pcall(function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
  end)
  assert_true(move_ok, "textobjects move should work: " .. tostring(move_err))

  vim.bo.modified = false
  vim.fn.delete(path)
end

local function run_default()
  assert_core()
  assert_inactive("nvim-dap")
  assert_no_map("n", "<F5>")
end

local function run_feature_rich()
  assert_core()

  assert_active("nvim-dap")
  assert_active("nvim-dap-ui")
  assert_active("nvim-dap-virtual-text")
  assert_active("nvim-dap-python")
  assert_active("nvim-nio")
  assert_active("nvim-treesitter-context")

  assert_map("n", "<F5>")
  assert_map("n", "<leader>dc")
  assert_python_treesitter()
end

local runners = {
  default = run_default,
  feature_rich = run_feature_rich,
}

local ok, err = xpcall(function()
  local runner = runners[scenario]
  assert_true(runner ~= nil, "unknown NVIM_SMOKE_SCENARIO: " .. tostring(scenario))
  runner()
end, debug.traceback)

if not ok then
  print(err)
  vim.cmd("cquit 1")
end

print("nvim smoke scenario passed: " .. scenario)
