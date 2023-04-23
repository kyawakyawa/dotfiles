local notify = {}

notify.setup = function(plugins)

  -- notify
  table.insert(plugins, {
    'rcarriga/nvim-notify',
    config = function()
      require("notify").setup({
        background_colour = "#000000",
      })
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
      'nvim-lua/plenary.nvim'
    }
  })

  return plugins
end

return notify
