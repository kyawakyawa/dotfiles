local avante_cfg = {}

local util = require('util')
local ollama = require('avante_cfg.ollama')
local mcp = require('avante_cfg.mcp')


avante_cfg_opts = {
  -- provider = "ollama",
  provider = avante_config_opts["provider"],
  -- auto_suggestions_provider = "copilot", -- Use Copilot for auto suggestions
  copilot = {
    model = "claude-3.7-sonnet",
    -- model = "gpt-4o",
    -- model = "gpt-4.1",
    -- model = "o3-mini", reasoning_effort = "high"
  },
  vendors = {
    ---@type AvanteProvider
    ollama = ollama,
  },
  system_prompt = mcp.system_prompt,
  custom_tools = mcp.custom_tools,
  -- disabled_tools = mcp.disabled_tools,
}

avante_cfg.opts = avante_cfg_opts


avante_cfg.opts = avante_cfg_opts

return avante_cfg
