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
  require('deps').setup(use)
end)
