local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

sbar.exec(
	"killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0"
)

local network_up = sbar.add("item", "widgets.network.up", {
	position = "right",
	icon = {
		string = icons.wifi.upload,
		color = colors.with_alpha(colors.accent, 0.70),
		padding_left = 8,
		padding_right = 2,
		font = { size = 11.0 },
	},
	label = { drawing = false },
})

local network = sbar.add("item", "widgets.network", {
	position = "right",
	label = {
		string = "–/–",
		color = colors.white,
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 11.0,
		},
		padding_left = 0,
		padding_right = 0,
	},
	update_freq = 2,
})

local network_down = sbar.add("item", "widgets.network.down", {
	position = "right",
	icon = {
		string = icons.wifi.download,
		color = colors.with_alpha(colors.blue, 0.70),
		padding_left = 2,
		padding_right = 8,
		font = { size = 11.0 },
	},
	label = { drawing = false },
})

network:subscribe("network_update", function(env)
	local up = env.upload:gsub(" Bps", "B"):gsub(" KiBps", "K"):gsub(" MiBps", "M")
	local down = env.download:gsub(" Bps", "B"):gsub(" KiBps", "K"):gsub(" MiBps", "M")
	network:set({ label = { string = down .. "/" .. up } })
end)
