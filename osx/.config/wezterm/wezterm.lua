local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- config.color_scheme = 'OneDark (base16)'
config.color_scheme = 'Catppuccin Mocha'
config.font_size = 13
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.hide_tab_bar_if_only_one_tab = true
config.force_reverse_video_cursor = true

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
