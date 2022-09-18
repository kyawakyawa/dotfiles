local brackets = {}

brackets.setup = function(use)

  -- nvim-autopairs
  use {
	  "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

end

return brackets
