local config = require("config")
local registry = require("plugin_registry")

local M = {}

local function by_id()
  local result = {}
  for _, plugin in ipairs(registry) do
    result[plugin.id] = plugin
  end
  return result
end

local function should_enable(plugin)
  if not config.env_allows(plugin) then
    return false
  end

  if plugin.dependency then
    local override = config.get_plugin_override(plugin.id)
    return override and override.enabled == true or false
  end

  return config.is_plugin_enabled(plugin)
end

local function add_dependency(id, plugins_by_id, enabled, visiting)
  if enabled[id] then
    return
  end

  local plugin = plugins_by_id[id]
  if not plugin then
    vim.notify("Unknown plugin dependency: " .. id, vim.log.levels.WARN)
    return
  end

  local override = config.get_plugin_override(id)
  if override and override.enabled == false then
    local msg = "Plugin dependency is disabled but required: " .. id
    if config.get("strict", false) then
      error(msg)
    end
    vim.notify(msg, vim.log.levels.WARN)
  end

  if visiting[id] then
    error("Circular plugin dependency: " .. id)
  end
  visiting[id] = true

  for _, dep in ipairs(plugin.dependencies or {}) do
    add_dependency(dep, plugins_by_id, enabled, visiting)
  end

  enabled[id] = true
  visiting[id] = nil
end

local function resolve_enabled_plugins()
  local plugins_by_id = by_id()
  local enabled = {}

  for _, plugin in ipairs(registry) do
    if should_enable(plugin) then
      for _, dep in ipairs(plugin.dependencies or {}) do
        add_dependency(dep, plugins_by_id, enabled, {})
      end
      enabled[plugin.id] = true
    end
  end

  local result = {}
  for _, plugin in ipairs(registry) do
    if enabled[plugin.id] then
      table.insert(result, plugin)
    end
  end

  return result
end

local function pack_specs(plugins)
  return vim.tbl_map(function(plugin)
    local spec = {
      src = plugin.src,
      name = plugin.id,
    }
    if plugin.version then
      spec.version = plugin.version
    end
    return spec
  end, plugins)
end

local function setup_plugins(plugins)
  for _, plugin in ipairs(plugins) do
    if plugin.setup then
      local ok, mod = pcall(require, plugin.setup)
      if not ok then
        vim.notify("Failed to load setup for " .. plugin.id .. ": " .. mod, vim.log.levels.ERROR)
      elseif mod.setup then
        local setup_ok, err = pcall(mod.setup)
        if not setup_ok then
          vim.notify("Failed to setup " .. plugin.id .. ": " .. err, vim.log.levels.ERROR)
        end
      end
    end
  end
end

function M.setup()
  local plugins = resolve_enabled_plugins()
  vim.pack.add(pack_specs(plugins), { confirm = false, load = true })
  setup_plugins(plugins)
end

M.setup()

return M
