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

  -- -- diffview.nvim
  -- use 'sindrets/diffview.nvim'

  -- -- vgit.nvim
  -- use ({
  --   'tanvirtin/vgit.nvim',
  --   config = function()
  --     require('vgit').setup()
  --   end,
  -- })

  return plugins
end

return git
