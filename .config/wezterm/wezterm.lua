local wezterm = require 'wezterm';

return {
  font = wezterm.font_with_fallback({
    "Delugia Nerd Font",
    "HackGenNerd",
  }),
  use_ime = true,
  font_size = 10.0,
  color_scheme = "Solarized Dark Higher Contrast",
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  exit_behavior = "Close",
  warn_about_missing_glyphs=false, -- フォントグリフが見つからないときの警告を出さない
  window_background_opacity=0.8,
  keys = {
    {key="F11", mods="CTRL|SHIFT", action="ToggleFullScreen"}, -- Ctrl + Shift + F!! でフルスクリーンのon/offができる
  }
}
