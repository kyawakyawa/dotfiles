local M = {}

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

function M.OSX()

  local has = function(x) 
    return vim.fn.has(x) == 1
  end

  local is_mac = has "macunix"
  
  if is_mac then
    return true
  else
    return false
  end
end

function M.isWSL()
  return checkMicrosoftInProcVersion()
end

function M.isSsh()
  return vim.loop.os_getenv("SSH_CONNECTION") ~= nil or vim.loop.os_getenv("SSH_CLIENT") ~= nil
end


return M
