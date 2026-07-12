local M = {}

function M.is_vscode()
  return vim.g.vscode ~= nil
end

function M.is_goneovim()
  return vim.g.goneovim ~= nil
end

function M.is_wsl()
  if vim.fn.has("wsl") == 1 then
    return true
  end

  local uv = vim.uv or vim.loop
  if uv and uv.os_uname then
    local release = uv.os_uname().release or ""
    return release:lower():find("microsoft", 1, true) ~= nil
  end

  local file = io.open("/proc/version", "r")
  if not file then
    return false
  end
  local content = file:read("*all")
  file:close()
  return content and content:lower():find("microsoft", 1, true) ~= nil
end

function M.is_macos()
  return vim.fn.has("macunix") == 1
end

function M.is_windows()
  return vim.fn.has("win32") == 1
end

function M.is_ssh()
  local uv = vim.uv or vim.loop
  return uv.os_getenv("SSH_CONNECTION") ~= nil or uv.os_getenv("SSH_CLIENT") ~= nil
end

return M
