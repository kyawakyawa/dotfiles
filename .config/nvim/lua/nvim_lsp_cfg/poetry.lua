local function getCurrentDir()
  return vim.fn.trim(vim.fn.system("pwd"))
end

local function get_poetry_venv_path(workspace)
  -- poetryがインストールされているか確認
  local is_poetry_installed = vim.fn.executable("poetry") == 1

  if not is_poetry_installed then
    -- poetryがインストールされていない場合、何もしない
    return nil
  end

  wd = (workspace == nil) and getCurrentDir() or workspace

  -- poetryでvirtualenvのパスを取得
  -- local venv_path = vim.fn.trim(vim.fn.system('cd ' .. wd .. ' && poetry env info -p'))
  local venv_path = vim.fn.trim(vim.fn.system("poetry env info -p"))

  -- poetryのvirtualenvが存在する場合、そのpythonパスを返す
  if vim.fn.isdirectory(venv_path) == 1 then
    -- return venv_path .. '/bin/python'
    return venv_path
  else
    return nil
  end
end

return {
  get_poetry_venv_path = get_poetry_venv_path,
}
