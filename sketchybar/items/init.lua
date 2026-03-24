local colors = require("colors")

-- Left section
require("items.apple")
require("items.spaces")

-- Center section
require("items.media")

-- Right section (Order: right to left)
-- Adding items in reverse order of their appearance from left to right.
require("items.calendar") -- Adds widgets.calendar (Date) then widgets.time (Time)
require("items.widgets.battery") -- Adds widgets.battery
-- require("items.widgets.cpu") -- Adds widgets.cpu
-- require("items.widgets.ram") -- Adds widgets.ram
require("items.widgets.wifi") -- Adds widgets.network (Network speed)

-- Left pill
sbar.add("bracket", { "apple.logo", "/space\\..*/" }, {
	background = {
		color = colors.bar.bg,
		corner_radius = 15,
	},
	padding_left = 0,
	padding_right = 0,
})

-- Right pill
sbar.add("bracket", { "/widgets\\..*/" }, {
	background = {
		color = colors.bar.bg,
		corner_radius = 15,
	},
	padding_left = 0,
	padding_right = 0,
})
