local avante_cfg = {}

local util = require('util')
local ollama = require('avante_cfg.ollama')
local mcp = require('avante_cfg.mcp')

local config = util.load_config()
avante_config_opts = config['plugins']['aiAssistant']['avante']['opts']

avante_cfg_opts = {
  provider = avante_config_opts["provider"],
  providers = {
    ollama = ollama,
    copilot = {
      model = avante_config_opts["providers"]["copilot"]["model"]
        or "gpt-4o",
    },
  },
  system_prompt = mcp.system_prompt,
  custom_tools = mcp.custom_tools,
  -- disabled_tools = mcp.disabled_tools,
}

avante_cfg.opts = avante_cfg_opts


avante_cfg.opts = avante_cfg_opts

return avante_cfg
