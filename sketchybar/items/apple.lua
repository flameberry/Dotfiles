require("utils")
local colors = require("colors")
local icons = require("icons")

sbar.add("item", "apple.logo", {
	position = "left",
	icon = {
		y_offset = 1,
		font = { size = 16.0 },
		color = colors.gold,
		string = icons.apple,
	},
	label = { drawing = false },
	padding_left = 4,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

sbar.add("item", { position = "left", width = 8 })
