local colors = require("colors")

return {
	paddings = 3,
	group_paddings = 5,

	icons = "sf-symbols", -- alternatively available: NerdFont

	font = require("helpers.default_font"),

	-- Alternatively, this is a font config for JetBrainsMono Nerd Font
	-- font = {
	-- 	text = "Satoshi Variable", -- Used for text
	-- 	numbers = "Satoshi Variable", -- Used for numbers
	-- 	style_map = {
	-- 		["Regular"] = "Regular",
	-- 		["Semibold"] = "Semibold",
	-- 		["Bold"] = "Bold",
	-- 		["Heavy"] = "Heavy",
	-- 		["Black"] = "Black",
	-- 	},
	-- },

	widget_bracket_bg = {
		color = colors.transparent,
		border_width = 0,
		corner_radius = 32,
		height = 32,
	},
}
