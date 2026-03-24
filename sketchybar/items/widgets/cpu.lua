local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("item", "widgets.cpu", {
	position = "right",
	icon = {
		string = icons.cpu,
		color = colors.magenta,
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

cpu:subscribe("cpu_update", function(env)
	cpu:set({
		label = { string = env.total_load .. "%" },
	})
end)
