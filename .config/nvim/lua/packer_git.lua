local git = {}

git.setup = function(use)

  -- gitsigns.nvim
  use ({
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  })

  -- diffview.nvim
  use 'sindrets/diffview.nvim'

  -- vgit.nvim
  use ({
    'tanvirtin/vgit.nvim',
    config = function()
      require('vgit').setup()
    end,
  })

end

return git
