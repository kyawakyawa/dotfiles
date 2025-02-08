local avante_cfg = {}

local util = require('util')
local config = util.load_config()
avante_config = config['plugins']['aiAssistant']['avante']
avante_config_opts = config['plugins']['aiAssistant']['avante']['opts']

avante_cfg_opts = {
  -- provider = "ollama",
  provider = avante_config_opts["provider"],
  vendors = {
    ---@type AvanteProvider
    ollama = {
      __inherited_from = "openai",
      api_key_name = "",
      endpoint = avante_config_opts["venders"]["ollama"]["endpoint"],
      model = avante_config_opts["venders"]["ollama"]["model"],
    },
  },
}

avante_cfg.opts = avante_cfg_opts

return avante_cfg
