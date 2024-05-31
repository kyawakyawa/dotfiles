local wezterm = require 'wezterm';

local config = wezterm.config_builder()

local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local is_windows = function()
	return wezterm.target_triple:find("windows") ~= nil
end

if is_linux() then
  config.default_prog = { "/bin/bash" }
elseif is_darwin() then
  config.default_prog = { "/bin/zsh" }
elseif is_windows() then
  config.default_prog = { "wsl.exe", "--distribution", "Arch", "--cd", "~" }
end

-- Font
config.font_size = 12.0
config.font = wezterm.font_with_fallback({
  "Delugia",
  "HackGenNerd",
})

-- IME
config.use_ime = true

-- Colorscheme etc
config.color_scheme = "Solarized Dark Higher Contrast"
-- config.color_scheme = "tokyonight-storm",
-- config.color_scheme = "terafox",
config.window_background_opacity=0.8

-- Key
config.keys = {
  {key="F11", mods="CTRL|SHIFT", action="ToggleFullScreen"}, -- Ctrl + Shift + F!! でフルスクリーンのon/offができる
}

-- Other
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.exit_behavior = "Close"
config.warn_about_missing_glyphs=false -- フォントグリフが見つからないときの警告を出さない
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 15,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 15,
}
config.audible_bell = "Disabled"
config.colors = {
  visual_bell = "#202020",
}
config.term = 'wezterm' -- TERM=weztermになる

return config
