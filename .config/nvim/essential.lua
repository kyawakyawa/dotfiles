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

local uv = vim.uv or vim.loop

local function is_wsl()
  if vim.fn.has("wsl") == 1 then
    return true
  end

  if not uv or not uv.os_uname then
    return false
  end

  local release = uv.os_uname().release or ""
  return release:lower():find("microsoft", 1, true) ~= nil
end

local function get_ime_off_command()
  if is_wsl() or vim.fn.has("win32") == 1 then
    if vim.fn.executable("zenhan") == 1 then
      return { "zenhan", "0" }
    end
    return nil
  end

  if vim.fn.has("mac") == 1 then
    if vim.fn.executable("/opt/homebrew/bin/im-select") == 1 then
      return { "/opt/homebrew/bin/im-select", "com.apple.keylayout.ABC" }
    end
    if vim.fn.executable("im-select") == 1 then
      return { "im-select", "com.apple.keylayout.ABC" }
    end
    return nil
  end

  if vim.fn.executable("fcitx5-remote") == 1 then
    return { "fcitx5-remote", "-c" }
  end

  return nil
end

local ime_off_command = get_ime_off_command()

if ime_off_command then
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      vim.fn.system(ime_off_command)
    end,
  })
end

-- builtin plugins
vim.cmd("packadd nvim.undotree")
