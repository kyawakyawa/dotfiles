local notify = {}
local util = require("util")

notify.setup = function(plugins)
  -- notify
  util.add_plugin(plugins, {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        top_down = false,
      })
      
      -- 表示されている通知を全て消す
      vim.keymap.set('n', '<leader>dn', function()
          require('notify').dismiss { silent = true }
      end, { desc = 'Dismiss notifications' })

      -- -- https://zenn.dev/kawarimidoll/articles/7e986ceb6802fc
      -- vim.cmd [[
      --   augroup notify_events
      --     autocmd! * ""<buffer>
      --     autocmd BufRead * lua vim.notify('BufRead ' .. vim.fn.expand('%'))
      --     autocmd BufEnter * lua vim.notify('BufEnter ' .. vim.fn.expand('%'))
      --     autocmd WinEnter * lua vim.notify('WinEnter ' .. vim.fn.winnr())
      --   augroup END
      -- ]]
    end,
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  }, {
    vscode = false,
  })

  return plugins
end

return notify
