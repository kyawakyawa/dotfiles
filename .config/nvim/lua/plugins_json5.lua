local json5 = {}

json5.setup = function(plugins)
  if vim.fn.executable('cargo') == 1 then
    local build_cmd = './install.sh'
    if vim.fn.has("win32") == 1 then
      build_cmd = 'powershell ./install.ps1'
    end

    table.insert(plugins, {
      'Joakker/lua-json5',
      build = build_cmd,
      lazy = true,
      event = "VeryLazy",
    })
  end

  return plugins
end

return json5
