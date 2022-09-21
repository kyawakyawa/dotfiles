local nightfox = {}

nightfox.setup = function(use)

  -- nightfox
  use ({
    'EdenEast/nightfox.nvim',
    config = function ()
      require('nightfox').setup({
        options = {
          transparent = true,
        },
      })
      vim.cmd[[colorscheme terafox]]
    end,
  })
end

return nightfox
