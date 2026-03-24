local settings = require("settings")
local colors = require("colors")

local cal = sbar.add("item", "widgets.calendar", {
	position = "right",
	icon = {
		string = "Tue 03 Feb",
		color = colors.white,
		padding_left = 4,
		padding_right = 4,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 12.0,
		},
	},
	label = { drawing = false },
	update_freq = 1,
})

local time = sbar.add("item", "widgets.time", {
	position = "right",
	icon = {
		string = "06:12 PM",
		color = colors.white,
		padding_left = 4,
		padding_right = 4,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 12.0,
		},
	},
	label = { drawing = false },
	update_freq = 1,
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ icon = { string = os.date("%a %d %b") } })
end)

time:subscribe({ "forced", "routine", "system_woke" }, function(env)
	time:set({ icon = { string = os.date("%I:%M %p") } })
end)
