local avante_cfg = {}

local util = require('util')
local ollama = require('avante_cfg.ollama')

avante_cfg_opts = {
  -- provider = "ollama",
  provider = avante_config_opts["provider"],
  vendors = {
    ---@type AvanteProvider
    ollama = ollama,
  },
}

avante_cfg.opts = avante_cfg_opts

return avante_cfg
