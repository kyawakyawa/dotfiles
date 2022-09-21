local wezterm = require 'wezterm';

return {
  -- Font
  font_size = 10.0,
  font = wezterm.font_with_fallback({
    "Delugia",
    "HackGenNerd",
  }),
  -- IME
  use_ime = true,
  -- Colorscheme etc
  -- color_scheme = "Solarized Dark Higher Contrast",
  -- color_scheme = "tokyonight-strom",
  color_scheme = "terafox",
  window_background_opacity=0.8,
  -- Key
  keys = {
    {key="F11", mods="CTRL|SHIFT", action="ToggleFullScreen"}, -- Ctrl + Shift + F!! でフルスクリーンのon/offができる
  },
  -- Other
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  exit_behavior = "Close",
  warn_about_missing_glyphs=false, -- フォントグリフが見つからないときの警告を出さない
  visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 15,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 15,
  },
  audible_bell = "Disabled",
  colors = {
    visual_bell = "#202020"
  },
}
