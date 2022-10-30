local dap = {}

dap.setup = function(use)

  -- nvim-dap
  use ({
    'mfussenegger/nvim-dap',
    config = function()
      require('nvim_dap_cfg')
    end,
  })

  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

  use ({
    'theHamsta/nvim-dap-virtual-text',
  })

end

return dap
