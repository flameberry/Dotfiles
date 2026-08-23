local utils = require("utils")
local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", "widgets.battery", {
	position = "right",
	icon = {
		font = {
			style = settings.font.style_map["Bold"],
			size = 14.0,
		},
		padding_left = 8,
		padding_right = 4,
	},
	label = {
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 12.0,
		},
		color = colors.white,
		padding_right = 10,
	},
	update_freq = 30,
})

local remaining_time = sbar.add("item", {
	position = "popup." .. battery.name,
	icon = {
		string = "Time remaining:",
		width = 110,
		align = "left",
		padding_left = 15,
	},
	label = {
		string = "??:??h",
		width = 110,
		align = "right",
		padding_right = 15,
	},
})

battery:subscribe({ "routine", "power_source_change", "system_woke", "brightness_change" }, function()
	sbar.exec("pmset -g batt", function(batt_info)
		local icon = "!"
		local label = "?"

		local found, _, charge = batt_info:find("(%d+)%%")
		if found then
			charge = tonumber(charge)
			label = charge .. "%"
		end

		local charging = batt_info:find("AC Power")

		-- Colour ladder. The accent can't carry "healthy": in several themes
		-- accent, red and love are the *same* value, so an accent-coloured full
		-- battery was indistinguishable from a critical one. Green reads as
		-- healthy, and red now means exactly one thing here — under 10%.
		-- Charging takes cyan so it stays separable from a merely-full green.
		local color
		if charging then
			icon = icons.battery.charging
			color = colors.blue
		elseif found and charge > 60 then
			icon = icons.battery._100
			color = colors.green
		elseif found and charge > 40 then
			icon = icons.battery._75
			color = colors.gold
		elseif found and charge > 20 then
			icon = icons.battery._50
			color = colors.orange
		elseif found and charge > 10 then
			icon = icons.battery._25
			color = colors.orange
		else
			icon = icons.battery._0
			color = colors.red
		end

		local lead = (found and charge < 10) and "0" or ""

		battery:set({
			icon = { string = icon, color = color },
			label = { string = lead .. label },
		})
	end)
end)

battery:subscribe("mouse.clicked", function(env)
	local drawing = battery:query().popup.drawing
	battery:set({ popup = { drawing = "toggle" } })

	if drawing == "off" then
		sbar.exec("pmset -g batt", function(batt_info)
			local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
			local label = found and remaining .. "h" or "No estimate"
			remaining_time:set({ label = label })
		end)
	end
end)

utils.hover_lift(battery)
