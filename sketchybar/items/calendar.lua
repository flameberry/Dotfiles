local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
-- sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", "widgets.calendar", {
	icon = {
		color = colors.white,
		-- padding_left = 15,
		padding_right = 0,
		font = {
			style = settings.font.style_map["Black"],
			size = 12.0,
		},
	},
	label = {
		color = colors.white,
		padding_right = 8,
		width = 50,
		align = "right",
		font = { family = settings.font },
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
