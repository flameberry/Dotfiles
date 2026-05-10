local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

sbar.exec(
	"killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0"
)

local function fmt(speed)
	return speed:gsub(" Bps", "B"):gsub(" KiBps", "K"):gsub(" MiBps", "M")
end

-- Fixed widths so the pill never resizes when the speed text changes width
-- (e.g. "003B" → "003KB" → "1.2M" all render in the same slot).
local item_width = 72

-- For position="right", earlier-added items render closer to the right edge.
-- Add up first (right of down), then down (left of up): final order ↓X ↑Y.

local network_up = sbar.add("item", "widgets.network.up", {
	position = "right",
	width = item_width,
	icon = {
		string = icons.wifi.upload,
		color = colors.with_alpha(colors.accent, 0.70),
		padding_left = 6,
		padding_right = 4,
		font = { size = 11.0 },
	},
	label = {
		string = "—",
		color = colors.white,
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 11.0,
		},
		padding_left = 0,
		padding_right = 4,
	},
})

local network_down = sbar.add("item", "widgets.network.down", {
	position = "right",
	width = item_width,
	icon = {
		string = icons.wifi.download,
		color = colors.with_alpha(colors.blue, 0.70),
		padding_left = 8,
		padding_right = 4,
		font = { size = 11.0 },
	},
	label = {
		string = "—",
		color = colors.white,
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 11.0,
		},
		padding_left = 0,
		padding_right = 0,
	},
})

network_down:subscribe("network_update", function(env)
	network_down:set({ label = { string = fmt(env.download or "—") } })
	network_up:set({ label = { string = fmt(env.upload or "—") } })
end)
