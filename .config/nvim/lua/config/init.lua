local env = require("config.env")

local M = {}

local uv = vim.uv or vim.loop

local state = {
  default_config_path = nil,
  config = nil,
  local_config_path = nil,
  warnings = {},
}

local function read_file(path)
  local fd = assert(io.open(path, "r"))
  local content = fd:read("*all")
  fd:close()
  return content
end

local function decode_jsonc(path)
  local content = read_file(path)
  return vim.json.decode(content, { skip_comments = true })
end

local function file_exists(path)
  return path ~= nil and uv.fs_stat(path) ~= nil
end

local function find_dir_upwards(start_path, target_dir)
  local current_path = start_path or uv.cwd()

  while current_path do
    local target_path = current_path .. "/" .. target_dir
    if file_exists(target_path) then
      return target_path
    end

    local parent_path = uv.fs_realpath(current_path .. "/..")
    if parent_path == nil or parent_path == current_path then
      return nil
    end
    current_path = parent_path
  end
end

local function find_local_config_path()
  local start_dir = uv.cwd()

  while true do
    local config_dir = find_dir_upwards(start_dir, ".nvim")
    if not config_dir then
      return nil
    end

    local config_path = config_dir .. "/config.json"
    if file_exists(config_path) then
      return config_path
    end

    local parent_dir = uv.fs_realpath(config_dir .. "/..")
    local parent_parent_dir = parent_dir and uv.fs_realpath(parent_dir .. "/..") or nil
    if parent_dir == nil or parent_parent_dir == nil or parent_dir == parent_parent_dir then
      return nil
    end

    start_dir = parent_parent_dir
  end
end

local function deep_extend(...)
  return vim.tbl_deep_extend("force", ...)
end

local function normalize(config)
  local function scrub(value)
    if value == vim.NIL then
      return nil
    end
    if type(value) ~= "table" then
      return value
    end

    local result = {}
    for key, item in pairs(value) do
      local scrubbed = scrub(item)
      if scrubbed ~= nil then
        result[key] = scrubbed
      end
    end
    return result
  end

  config = scrub(config)

  if config.version == nil then
    config.version = 1
  end
  if config.strict == nil then
    config.strict = false
  end
  config.features = config.features or {}
  config.languages = config.languages or {}
  config.plugins = config.plugins or {}
  return config
end

local function split_path(path)
  if type(path) == "table" then
    return path
  end

  local parts = {}
  for part in tostring(path):gmatch("[^.]+") do
    table.insert(parts, part)
  end
  return parts
end

function M.setup(opts)
  opts = opts or {}
  state.default_config_path = opts.default_config_path or state.default_config_path
  state.config = nil
  state.local_config_path = nil
  state.warnings = {}
end

function M.load()
  if state.config then
    return state.config
  end

  if not state.default_config_path then
    error("config.setup({ default_config_path = ... }) must be called before config.load()")
  end

  local default_config = decode_jsonc(state.default_config_path)
  local local_config_path = find_local_config_path()
  local merged = default_config

  if local_config_path then
    local local_config = decode_jsonc(local_config_path)
    merged = deep_extend(default_config, local_config)
    state.local_config_path = local_config_path
  end

  state.config = normalize(merged)
  return state.config
end

function M.get(path, default)
  local value = M.load()
  if path == nil then
    return value
  end

  for _, part in ipairs(split_path(path)) do
    if type(value) ~= "table" then
      return default
    end
    value = value[part]
    if value == nil then
      return default
    end
  end

  return value
end

function M.get_feature(path)
  return M.get("features." .. path)
end

function M.is_feature_enabled(path)
  local parts = split_path(path)
  local group = table.remove(parts, 1)
  local feature = M.get("features." .. group)

  if feature == nil then
    return false
  end
  if type(feature) == "table" and feature.enabled == false then
    return false
  end
  if #parts == 0 then
    return type(feature) == "table" and feature.enabled ~= false or feature == true
  end

  local value = feature
  for _, part in ipairs(parts) do
    if type(value) ~= "table" then
      return false
    end
    value = value[part]
  end

  if value == nil then
    return type(feature) == "table" and feature.enabled ~= false
  end
  return value ~= false and value ~= nil
end

function M.get_plugin_override(id)
  return M.get({ "plugins", id })
end

function M.is_plugin_enabled(plugin)
  local id = type(plugin) == "table" and plugin.id or plugin
  local override = M.get_plugin_override(id)

  if override and override.enabled ~= nil then
    return override.enabled
  end

  if type(plugin) == "table" and plugin.feature then
    return M.is_feature_enabled(plugin.feature)
  end

  return true
end

function M.env_allows(plugin)
  local plugin_env = plugin.env or {}
  local vscode = plugin_env.vscode

  if vscode == nil or vscode == "any" then
    return true
  end

  if vscode == true then
    return env.is_vscode()
  end

  if vscode == false then
    return not env.is_vscode()
  end

  return true
end

function M.local_config_path()
  M.load()
  return state.local_config_path
end

function M.default_config_path()
  return state.default_config_path
end

function M.print_info()
  local cfg = M.load()
  print("default_config: " .. tostring(state.default_config_path))
  print("local_config: " .. tostring(state.local_config_path or "not found"))
  print("version: " .. tostring(cfg.version))
end

return M
