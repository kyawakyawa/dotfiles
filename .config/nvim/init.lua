-- cacheの設定 (https://zenn.dev/kawarimidoll/articles/19bfc63e1c218c)
if vim.loader then vim.loader.enable() end

vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.cindent = true
vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.smartindent = true
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.updatetime = 250
vim.opt.laststatus = 3 -- https://wed.dev/blog/posts/neovim-statuline
  
if not vim.g.vscode then
  vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', { noremap = true })

-- Plugins
  require('plugins') -- プラグインの読み込み
end

-- Macの時
if require('util').OSX() then
  -- For IME
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = { "*" },
    callback = function() vim.fn.system('im-select com.apple.inputmethod.Kotoeri.RomajiTyping.Roman') end,
  })
-- Linuxのとき
else
  -- For IME
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = { "*" },
    callback = function() vim.fn.system('fcitx5-remote -c') end,
  })
end
