local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

sbar.add("item", "front_app_arrow", {
	width = 8,
	label = { drawing = false },
	associated_display = "active",
})

local front_app = sbar.add("item", "front_app_text", {
	display = "active",
	icon = { drawing = false },
	padding_left = 8,
	padding_right = 8,
	y_offset = 1,
	label = {
		color = colors.text,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Heavy"],
			size = 12.0,
		},
	},
	updates = true,
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({ label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)

-- Middle section of the menu bar
require("utils")
menubar_section({ "front_app_text" })
