local colors = require("colors")
local icons = require("icons")

local padding = sbar.add("item", { position = "left", width = 8 })

sbar.add("item", "apple.logo", {
	icon = {
		y_offset = 1,
		font = { size = 16.0 },
		color = colors.rose,
		string = icons.apple,
	},
	label = { drawing = false },
	padding_right = 8,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

sbar.add("bracket", "apple", { padding.name, "apple.logo" }, {
	background = {
		color = colors.transparent,
	},
})
