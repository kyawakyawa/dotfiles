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

function checkMicrosoftInProcVersion()
    local file = io.open("/proc/version", "r")
    
    if file then
        local content = file:read("*all")
        file:close()

        if content and string.find(content, "microsoft") then
            return true
        else
            return false
        end
    else
        return false
    end
end

function isWSL()
  return checkMicrosoftInProcVersion()
end
  
if not vim.g.vscode then
  -- For OpenCL
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead"}, {
    pattern = { "*.cl" },
    callback = function() vim.opt.filetype=cl end,
  })
  
  vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', { noremap = true })

-- Plugins
  require('plugins') -- プラグインの読み込み
end

if isWSL() then
  --WSLの時

  -- Windows側にzenhan.exeを置き、WSL側にシンボリックリンク /usr/local/bin/zenhan を作成
  -- For IME
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = { "*" },
    callback = function()
      vim.fn.system('zenhan 0')
    end,
  })
elseif require('util').OSX() then
  -- Macの時
  -- For IME
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = { "*" },
    callback = function() vim.fn.system('im-select com.apple.inputmethod.Kotoeri.RomajiTyping.Roman') end,
  })
else
  -- Linuxのとき
  -- For IME
  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    pattern = { "*" },
    callback = function() vim.fn.system('fcitx5-remote -c') end,
  })
end
