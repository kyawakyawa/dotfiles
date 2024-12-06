local function getCurrentDir()
    return vim.fn.trim(vim.fn.system('pwd'))
end

local function file_exists(path)
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil
end

local function is_exists_venv_path(venv_path)
  if not file_exists(venv_path) then
    return false
  end

  local python_path = venv_path .. '/bin/python'
  if not file_exists(python_path) then
    return false
  end

  return true
end

local function search_venv_path(workspace)
  local cands = {"venv", ".venv", "virtualenv", ".virtualenv"}

  local wd = (workspace == nil) and getCurrentDir() or workspace

  for i = 1, #cands do
    if is_exists_venv_path(wd .. "/" ..cands[i]) then
      return wd .. "/" ..cands[i]
    end
  end
  return nil
end

return {
  search_venv_path = search_venv_path
}
