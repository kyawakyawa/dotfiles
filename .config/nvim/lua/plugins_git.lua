local git = {}

git.setup = function(plugins)

  -- gitsigns.nvim
  table.insert(plugins, {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  	lazy = true,
	  event = { "CursorHold", "CursorHoldI" },
  })

  return plugins
end

return git
