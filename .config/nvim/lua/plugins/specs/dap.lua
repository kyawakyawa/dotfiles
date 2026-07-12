local config = require("config")

local M = {}

local function setup_keymaps(cfg)
  local dap = require("dap")

  if cfg.ui ~= false then
    local dapui = require("dapui")
    vim.keymap.set("n", "<leader>d", dapui.toggle, { silent = true, desc = "DAP UI toggle" })
    vim.keymap.set("n", "<leader>w", dapui.elements.watches.add, {
      silent = true,
      desc = "DAP add watch",
    })
    vim.keymap.set(
      "n",
      "<leader><leader>df",
      dapui.eval,
      { silent = true, desc = "DAP eval" }
    )
  end
  vim.keymap.set("n", "<F5>", dap.continue, { silent = true, desc = "DAP continue" })
  vim.keymap.set("n", "<F10>", dap.step_over, { silent = true, desc = "DAP step over" })
  vim.keymap.set("n", "<F11>", dap.step_into, { silent = true, desc = "DAP step into" })
  vim.keymap.set("n", "<F12>", dap.step_out, { silent = true, desc = "DAP step out" })
  vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {
    silent = true,
    desc = "DAP toggle breakpoint",
  })
  vim.keymap.set("n", "<leader>bc", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { silent = true, desc = "DAP conditional breakpoint" })
  vim.keymap.set("n", "<leader>l", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end, { silent = true, desc = "DAP log point" })
  vim.keymap.set("n", "<leader>dc", dap.repl.close, { silent = true, desc = "DAP close repl" })
end

local function load_launch_json()
  require("dap.ext.vscode").load_launchjs()
end

function M.setup()
  local cfg = config.get("features.debug", {})
  local dap = require("dap")

  if cfg.ui ~= false then
    require("dapui").setup()
    dap.listeners.before.event_initialized.dapui_config = function()
      require("dapui").open()
    end
  end

  if cfg.codelldb ~= false then
    dap.adapters.lldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
      },
    }
  end

  if cfg.python ~= false then
    local resolved = require("python_env").resolve(vim.uv.cwd())
    require("dap-python").setup(resolved and resolved.python or nil, {
      include_configs = false,
    })
  end

  if cfg.virtual_text ~= false then
    require("nvim-dap-virtual-text").setup()
  end

  if cfg.launch_json ~= false then
    load_launch_json()
  end

  setup_keymaps(cfg)
end

return M
