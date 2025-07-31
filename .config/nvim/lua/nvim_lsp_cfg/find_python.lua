local function find_python_base_dir()
  local python_base_path = vim.fn.trim(
    vim.fn.system('dirname $(dirname $(python -c "import sys; print(sys.executable)"))')
  )

  if vim.fn.isdirectory(python_base_path) == 1 then
    return python_base_path
  else
    return nil
  end
end

return {
  find_python_base_dir = find_python_base_dir,
}
