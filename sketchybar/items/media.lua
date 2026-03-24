local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local whitelist = { ["Spotify"] = true, ["Google Chrome"] = true }

local media = sbar.add("item", "widgets.media", {
	position = "center",
	icon = {
		string = ":spotify:",
		font = "sketchybar-app-font:Regular:14.0",
		color = 0xff1db954, -- Spotify green
		padding_left = 12,
		padding_right = 8,
	},
	label = {
		string = "Artist - Title",
		font = { family = settings.font.text, style = settings.font.style_map["Bold"], size = 12 },
		color = colors.white,
		padding_right = 12,
		max_chars = 35,
	},
	background = {
		color = colors.bg1,
		height = 26,
		corner_radius = 13,
	},
	drawing = false,
	updates = true,
})

media:subscribe("media_change", function(env)
	if whitelist[env.INFO.app] then
		local drawing = (env.INFO.state == "playing")
		local title = env.INFO.title
		local artist = env.INFO.artist
		local app = env.INFO.app

		local icon = ":default:"
		local color = colors.text

		if app == "Spotify" then
			icon = ":spotify:"
			color = 0xff1db954
		elseif app == "Google Chrome" then
			icon = ":google_chrome:"
			color = colors.blue
		end

		media:set({
			drawing = drawing,
			icon = { string = icon, color = color },
			label = { string = artist .. " - " .. title },
		})
	end
end)

media:subscribe("mouse.clicked", function(env)
	sbar.exec("nowplaying-cli togglePlayPause")
end)
