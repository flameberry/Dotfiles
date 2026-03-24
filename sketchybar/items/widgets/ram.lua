local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("item", "widgets.ram", {
	position = "right",
	icon = {
		string = icons.memory,
		color = colors.blue,
		padding_left = 4,
		padding_right = 4,
	},
	label = {
		string = "??%",
		color = colors.white,
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 12.0,
		},
		padding_right = 4,
	},
	update_freq = 2,
})

ram:subscribe({ "routine", "forced" }, function(env)
	sbar.exec("memory_pressure | grep 'System-wide memory free percentage:' | awk '{ print 100-$5 }'", function(load)
		ram:set({
			label = { string = math.floor(tonumber(load)) .. "%" },
		})
	end)
end)