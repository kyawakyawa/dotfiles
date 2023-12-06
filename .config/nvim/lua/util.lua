local M = {}

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

return M

