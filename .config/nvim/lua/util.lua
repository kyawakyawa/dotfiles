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
  return vim.uv.os_getenv("SSH_CONNECTION") ~= nil or vim.uv.os_getenv("SSH_CLIENT") ~= nil
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

function M.find_dir_upwards(start_path, target_dir)
    local uv = vim.uv
    local current_path = start_path or uv.cwd()

    while current_path do
        -- local target_path = uv.fs_realpath(current_path .. "/" .. target_dir) -- こっちにすると、シンボリックリンクの参照先を返すようになる
        local target_path = current_path .. "/" .. target_dir
        if target_path and uv.fs_stat(target_path) then
            return target_path
        end

        local parent_path = uv.fs_realpath(current_path .. "/..")
        if parent_path == current_path then
            -- ルートディレクトリまで到達した
            return nil
        end
        current_path = parent_path
    end
end

local config_path_loaded = nil
local default_config_path = "~/.config/nvim/default_config.json"

function M.set_default_config_path(path)
  default_config_path = path
end
function M.get_default_config_path(path)
  return default_config_path
end

local load_default_config = function()
    local f = io.open(default_config_path, 'r')
    if not f then
        error("Failed to open default config file: " .. default_config_path)
    end
    local content = f:read("*all")
    f:close()

    -- デフォルトのconfigはjson5で書かれていないことを前提にする。
    return vim.fn.json_decode(content)
end

local load_local_config = function() 
  local config_dir = M.find_dir_upwards(nil, ".nvim")
  if not config_dir then
    return nil
  end

  config_path = config_dir .. "/config.json"

  if vim.uv.fs_stat(config_path) then
    json_decoder = vim.fn.json_decode

    -- TODO: json5のサポートを追加する (lazy.nvimのload前に読む必要がある)
    -- local ok, json5 = pcall(require, 'json5')
    -- if ok then
    --   json_decoder = require('json5').parse
    -- end

    local f = io.open(config_path, 'r')
    if not f then
        error("Failed to open local config file: " .. config_path)
    end
    local content = f:read("*all")
    f:close()

    json = json_decoder(content)

    config_path_loaded = config_path

    return json
  else
    return nil
  end
end

function M.load_config()
  local default_config = load_default_config()
  local local_config = load_local_config()

  return vim.tbl_deep_extend("force", default_config, local_config or {})
end

function M.get_config_path()
  return config_path_loaded
end

return M
