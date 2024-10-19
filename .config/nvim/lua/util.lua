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

function M.isVscode()
  return vim.g.vscode
end


function M.add_plugin(plugins, obj, opts)

  local default_opts = {
    vscode = false,
  }
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", default_opts, opts)

  if not opts.vscode and M.isVscode() then
    return
  end

  table.insert(plugins, obj)
end


return M
