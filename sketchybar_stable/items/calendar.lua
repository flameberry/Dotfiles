local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
-- sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", "widgets.calendar", {
	icon = {
		color = colors.iris,
		padding_left = 8,
		padding_right = 0,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 12.0,
		},
	},
	label = {
		color = colors.text,
		padding_right = 8,
		width = 50,
		align = "right",
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
		},
		y_offset = 1,
	},
	position = "right",
	update_freq = 1,
	-- padding_left = 15,
})

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	local time = os.date("%I:%M")
	sbar.animate("tanh", 5, function()
		cal:set({ icon = os.date("%a %d %b"), label = time })
	end)
end)
