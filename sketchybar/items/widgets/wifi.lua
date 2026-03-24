local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "network_update"
-- for the network interface "en0", which is fired every 2.0 seconds.
sbar.exec(
	"killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0"
)

local network_down = sbar.add("item", "widgets.network.down", {
	position = "right",
	icon = {
		string = icons.wifi.download,
		color = colors.white,
		padding_left = 0,
		padding_right = 4,
		font = { size = 12.0 },
	},
	label = { drawing = false },
})

local network = sbar.add("item", "widgets.network", {
	position = "right",
	icon = {
		string = icons.wifi.upload,
		color = colors.white,
		padding_left = 4,
		padding_right = 4,
		font = { size = 12.0 },
	},
	label = {
		string = "0K/0K",
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

network:subscribe("network_update", function(env)
	local up = env.upload:gsub(" Bps", "B"):gsub(" KiBps", "K"):gsub(" MiBps", "M")
	local down = env.download:gsub(" Bps", "B"):gsub(" KiBps", "K"):gsub(" MiBps", "M")
	network:set({
		label = { string = down .. "/" .. up },
	})
end)
