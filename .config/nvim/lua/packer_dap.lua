local dap = {}

dap.setup = function(use)

  -- nvim-dap
  use ({
    'mfussenegger/nvim-dap',
    config = function()
      require('nvim_dap_cfg')
    end,
  })

  -- nvim-dap-ui
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

  use ({
    'theHamsta/nvim-dap-virtual-text',
  })

  -- nvim-dap-python
  use ({
    'mfussenegger/nvim-dap-python'
  })

end

return dap
