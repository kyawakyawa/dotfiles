local line = {}

line.setup = function(plugins)

  -- lualine.nvim
  table.insert(plugins, {
    'nvim-lualine/lualine.nvim',
    lazy = true,
    event = 'VeryLazy',
    config = function()
      require('lualine_cfg')
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  })

  -- -- barbar.nvim
  table.insert(plugins, {
    'romgrk/barbar.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function() vim.g.barbar_auto_setup = false end,
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
  })

  -- -- sidebar.nvim
  -- table.insert(plugins, {
  --   'sidebar-nvim/sidebar.nvim',
  --   config = function()
  --     local sidebar = require("sidebar-nvim")
  --     sidebar.setup({
  --       sections = {
  --         "datetime",
  --         "git",
  --         "diagnostics",
  --         require("dap-sidebar-nvim.breakpoints")
  --       },
  --       dap = {
  --           breakpoints = {
  --               icon = "🔍"
  --           }
  --       }
  --     })

  --     local bufopts = { noremap=true }
  --     vim.keymap.set('n', '<space>s', require("sidebar-nvim").toggle, bufopts)
  --   end,
  -- })

  -- -- sections-dap
  -- table.insert(plugins, {
  --   'sidebar-nvim/sections-dap',
  -- })

  return plugins
end

return line
