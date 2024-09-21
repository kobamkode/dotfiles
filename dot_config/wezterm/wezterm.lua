local wezterm = require("wezterm")
local config = {}

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 10.7
config.line_height = 1.0
config.hide_tab_bar_if_only_one_tab = true
config.prefer_to_spawn_tabs = true

return config
