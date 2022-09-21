-- packer.nvim
-- ~/.local/share/nvim/site/pack/packer/start
-- か
-- ~/.local/share/nvim/site/pack/packer/opt
-- にインストール
-- (startは起動時に読み込み, optは遅延して読み込む(packaddしたとき)


-- packer.nvim を
-- ~/.local/share/nvim/site/pack/packer/opt
-- にインストールした場合に以下が必要

-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- dependencies
  require('packer_deps').setup(use)

  -- nvim lsp
  require('packer_nvim_lsp').setup(use)

  -- complement
  require('packer_complement').setup(use)

  -- fuzzy finder
  require('packer_fuzzy_finder').setup(use)

  -- file explorer
  require('packer_file_explorer').setup(use)

  -- line
  require('packer_line').setup(use)

  -- git
  require('packer_git').setup(use)

  -- brackets
  require('packer_brackets').setup(use)

  -- syntax highlight
  require('packer_syntax_highlight').setup(use)

  -- -- tokyonight colorscheme
  -- require('packer_tokyonight').setup(use)

  -- nightfox colorscheme
  require('packer_nightfox').setup(use)

end)
