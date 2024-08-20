local colors = require("colors")
local icons = require("icons")

-- Padding item required because of bracket
-- sbar.add("item", { width = 5 })

local apple = sbar.add("item", {
	icon = {
		font = { size = 16.0 },
		color = colors.green,
		string = icons.apple,
	},
	label = { drawing = false },
	padding_right = 15,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
	background = {
		color = colors.transparent,
		height = 30,
		border_color = colors.grey,
	},
})

-- Padding item required because of bracket
-- sbar.add("item", { width = 7 })
