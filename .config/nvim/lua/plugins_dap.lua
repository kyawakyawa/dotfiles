local dap = {}

dap.setup = function(plugins)

  -- nvim-dap
  table.insert(plugins, {
    'mfussenegger/nvim-dap',
    config = function()
      require('nvim_dap_cfg')
    end,
    dependencies = {
      { "rcarriga/nvim-dap-ui" },
      { 'theHamsta/nvim-dap-virtual-text' },
      { 'mfussenegger/nvim-dap-python' },
    },
    lazy = true,
    keys = {
      "<leader>d",
      "<leader><leader>df",
      "<F5>",
      "<F10>",
      "<F11>",
      "<F12>",
      "<leader>b",
      "<leader>bc",
      "<leader>l",
      "<leader>c",
    }
  })

  return plugins
end

return dap
