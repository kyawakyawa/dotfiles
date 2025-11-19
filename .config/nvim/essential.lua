vim.cmd([[
  set nocompatible
  filetype plugin on
  set number
  syntax enable
  set expandtab
  set tabstop=2
  set shiftwidth=2
  set cindent
  set hlsearch
  set cursorline
  set smartindent
  set hidden
  colorscheme vim
]])

-- Python provider 完全オフ
vim.g.loaded_python3_provider = 0
-- もしPython providerを使う場合は以下を書く(Pyenv環境だとshimが遅くて起動が遅れるので使うPythonを明示的に指定する)
-- vim.g.python3_host_prog = '/usr/bin/python3'

-- その他使わないproviderもオフにする
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0