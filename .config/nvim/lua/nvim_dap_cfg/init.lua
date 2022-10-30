-- Set up nvim-dap
-- launch.jsonの利用 (.vscode/launch.json)


require('dap.ext.vscode').load_launchjs(nil, { 
  lldb = {'c', 'cpp'} -- dap.configurations.cpp の変わりにlaunch.jsonを使う
})
-- 参考
-- - https://github.com/mfussenegger/nvim-dap/issues/20#issuecomment-1212214935

-- UIの自動起動
require'dap'.listeners.before['event_initialized']['custom'] = function(session, body)
  require'dapui'.open()
end

-- -- UIの自動消去
-- require'dap'.listeners.before['event_terminated']['custom'] = function(session, body)
--   require'dapui'.close()
-- end

require("dapui").setup()

-- Key Map
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<leader>d", ":lua require'dapui'.toggle()<CR>", { silent = true})
map("n", "<leader><leader>df", ":lua require'dapui'.eval()<CR>", { silent = true})
map("n", "<F5>", ":lua require'dap'.continue()<CR>", { silent = true})
map("n", "<F10>", ":lua require'dap'.step_over()<CR>", { silent = true})
map("n", "<F11>", ":lua require'dap'.step_into()<CR>", { silent = true})
map("n", "<F12>", ":lua require'dap'.step_out()<CR>", { silent = true})
map("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true})
map("n", "<leader>bc", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { silent = true})
map("n", "<leader>l", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { silent = true})
vim.keymap.set('n', '<leader>c', require'dap'.repl.close, { silent = true}, bufopts)

-- C++ with codelldb
local dap = require('dap')
dap.adapters.lldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = 'codelldb',
    args = {"--port", "${port}"},

    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}

-- virtual text
require("nvim-dap-virtual-text").setup()

-- dap.configurations.cpp = {
--   {
--     name = "Launch file",
--     type = "lldb",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = true,
--   },
-- }

-- -- DAP UI
-- require("dapui").setup({
--   icons = { expanded = "▾", collapsed = "▸" },
--   mappings = {
--     -- Use a table to apply multiple mappings
--     expand = { "<CR>", "<2-LeftMouse>" },
--     open = "o",
--     remove = "d",
--     edit = "e",
--     repl = "r",
--     toggle = "t",
--   },
--   -- Expand lines larger than the window
--   -- Requires >= 0.7
--   expand_lines = vim.fn.has("nvim-0.7"),
--   -- Layouts define sections of the screen to place windows.
--   -- The position can be "left", "right", "top" or "bottom".
--   -- The size specifies the height/width depending on position. It can be an Int
--   -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
--   -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
--   -- Elements are the elements shown in the layout (in order).
--   -- Layouts are opened in order so that earlier layouts take priority in window sizing.
--   layouts = {
--     {
--       elements = {
--       -- Elements can be strings or table with id and size keys.
--         { id = "scopes", size = 0.25 },
--         "breakpoints",
--         "stacks",
--         "watches",
--       },
--       size = 40, -- 40 columns
--       position = "left",
--     },
--     {
--       elements = {
--         "repl",
--         "console",
--       },
--       size = 0.25, -- 25% of total lines
--       position = "bottom",
--     },
--   },
--   floating = {
--     max_height = nil, -- These can be integers or a float between 0 and 1.
--     max_width = nil, -- Floats will be treated as percentage of your screen.
--     border = "single", -- Border style. Can be "single", "double" or "rounded"
--     mappings = {
--       close = { "q", "<Esc>" },
--     },
--   },
--   windows = { indent = 1 },
--   render = {
--     max_type_length = nil, -- Can be integer or nil.
--   }
-- })
-- 
-- -- nvim DAP virtual text
-- require("nvim-dap-virtual-text").setup()
-- 
-- -- launch.jsonの利用 (.vscode/launch.json)
-- require('dap.ext.vscode').load_launchjs()
-- 
-- -- UIの自動起動
-- require'dap'.listeners.before['event_initialized']['custom'] = function(session, body)
--   require'dapui'.open()
-- end
-- 
-- -- UIの自動消去
-- require'dap'.listeners.before['event_terminated']['custom'] = function(session, body)
--   require'dapui'.close()
-- end
-- 
-- -- Key Map
-- local function map(mode, lhs, rhs, opts)
--     local options = {noremap = true}
--     if opts then options = vim.tbl_extend('force', options, opts) end
--     vim.api.nvim_set_keymap(mode, lhs, rhs, options)
-- end
-- 
-- map("n", "<leader>d", ":lua require'dapui'.toggle()<CR>", { silent = true})
-- map("n", "<leader><leader>df", ":lua require'dapui'.eval()<CR>", { silent = true})
-- map("n", "<F5>", ":lua require'dap'.continue()<CR>", { silent = true})
-- map("n", "<F10>", ":lua require'dap'.step_over()<CR>", { silent = true})
-- map("n", "<F11>", ":lua require'dap'.step_into()<CR>", { silent = true})
-- map("n", "<F12>", ":lua require'dap'.step_out()<CR>", { silent = true})
-- map("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true})
-- map("n", "<leader>bc", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { silent = true})
-- map("n", "<leader>l", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { silent = true})
-- 
-- 
-- -- Python
-- local venv = os.getenv('VIRTUAL_ENV')
-- command = string.format('%s/bin/python', venv)
-- 
-- require('dap-python').setup(command)
