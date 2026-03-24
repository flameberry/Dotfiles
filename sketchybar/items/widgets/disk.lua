local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local disk = sbar.add("item", "widgets.disk", {
	position = "right",
	icon = {
		string = icons.disk,
		color = colors.text,
		padding_left = 5,
		padding_right = 5,
	},
	label = {
		string = "??%",
		color = colors.text,
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 12.0,
		},
		padding_right = 10,
	},
	update_freq = 60,
})

disk:subscribe({ "routine", "forced" }, function(env)
	sbar.exec("df -H / | awk 'NR==2 {print $5}'", function(load)
		disk:set({
			label = { string = load:gsub("%%", "") .. "%" },
		})
	end)
end)