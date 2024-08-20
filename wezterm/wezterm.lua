-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
-- config.color_scheme = "Solarized Dark Higher Contrast"
-- config.color_scheme = "Catppuccin Mocha"

-- Coolnight colorscheme
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

-- config.font = wezterm.font("JetbrainsMono Nerd Font")
-- config.font = wezterm.font("OperatorMonoSSmLig Nerd Font")
-- config.font = wezterm.font("Liga SFMono Nerd Font")
config.font = wezterm.font("MesloLGS Nerd Font", { weight = "Bold" })
-- config.font = wezterm.font("Hack")
-- config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 15

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.9
config.window_background_opacity = 1
config.macos_window_background_blur = 15

-- config.window_background_gradient = {
-- 	orientation = "Vertical",
-- 	colors = {
-- 		"#1E1E2F",
-- 		"#1E1E2F",
-- 	},
-- 	blend = "Rgb",
-- 	interpolation = "Linear",
-- }

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

-- and finally, return the configuration to wezterm
return config
