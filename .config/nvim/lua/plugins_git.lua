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

  -- neogit
  table.insert(plugins, {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
  
      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
    lazy = true,
  	event = "BufReadPost",
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
