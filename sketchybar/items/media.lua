local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local icons = require("icons")

-- For position="center", earlier-added items render to the LEFT.
-- Add prev → media → next so they appear in that order.

local prev = sbar.add("item", "center.media.prev", {
	position = "center",
	icon = {
		string = icons.media.back,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 12,
		},
		color = colors.with_alpha(colors.accent, 0.65),
		padding_left = 14,
		padding_right = 6,
	},
	label = { drawing = false },
	click_script = "nowplaying-cli previous",
})

local media = sbar.add("item", "center.media", {
	position = "center",
	icon = {
		string = "♫",
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 14,
		},
		color = colors.with_alpha(colors.accent, 0.35),
		padding_left = 4,
		padding_right = 6,
	},
	label = {
		string = "nothing playing",
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 12,
		},
		color = colors.with_alpha(colors.white, 0.30),
		padding_right = 6,
		max_chars = 14,
	},
	update_freq = 5,
	updates = true,
})

local next_btn = sbar.add("item", "center.media.next", {
	position = "center",
	icon = {
		string = icons.media.forward,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 12,
		},
		color = colors.with_alpha(colors.accent, 0.65),
		padding_left = 6,
		padding_right = 14,
	},
	label = { drawing = false },
	click_script = "nowplaying-cli next",
})

local function set_idle()
	sbar.animate("tanh", 10, function()
		media:set({
			icon = {
				string = "♫",
				font = {
					family = settings.font.text,
					style = settings.font.style_map["Bold"],
					size = 14,
				},
				color = colors.with_alpha(colors.accent, 0.35),
			},
			label = {
				string = "nothing playing",
				color = colors.with_alpha(colors.white, 0.30),
			},
		})
		prev:set({ icon = { color = colors.with_alpha(colors.accent, 0.30) } })
		next_btn:set({ icon = { color = colors.with_alpha(colors.accent, 0.30) } })
	end)
end

local function set_playing(title, artist, app)
	local lookup = app and app ~= "" and app_icons[app]
	local icon_str, icon_font, icon_color

	if lookup then
		icon_str = lookup
		icon_font = { family = "sketchybar-app-font", style = "Regular", size = 14 }
		icon_color = (app == "Spotify") and 0xff1db954 or colors.accent
	else
		icon_str = "♫"
		icon_font = { family = settings.font.text, style = settings.font.style_map["Bold"], size = 14 }
		icon_color = colors.accent
	end

	local display = (artist ~= "" and (artist .. " – ") or "") .. title

	sbar.animate("tanh", 10, function()
		media:set({
			icon = { string = icon_str, font = icon_font, color = icon_color },
			label = { string = display, color = colors.white },
		})
		prev:set({ icon = { color = colors.with_alpha(colors.accent, 0.85) } })
		next_btn:set({ icon = { color = colors.with_alpha(colors.accent, 0.85) } })
	end)
end

local function poll()
	sbar.exec(
		'printf \'%s\\t%s\\t%s\' "$(nowplaying-cli get playbackRate)" "$(nowplaying-cli get title)" "$(nowplaying-cli get artist)"',
		function(out)
			local rate_str, title, artist = out:match("([^\t]*)\t([^\t]*)\t(.*)")
			local rate = tonumber(rate_str) or 0
			title = title and title:gsub("^%s*(.-)%s*$", "%1") or ""
			artist = artist and artist:gsub("^%s*(.-)%s*$", "%1") or ""

			if rate > 0 and title ~= "" then
				set_playing(title, artist, nil)
			else
				set_idle()
			end
		end
	)
end

local function poll_after(cmd)
	sbar.exec(cmd, function()
		sbar.exec("sleep 0.3 && true", function()
			poll()
		end)
	end)
end

media:subscribe({ "routine", "system_woke" }, poll)
media:subscribe("mouse.clicked", function()
	poll_after("nowplaying-cli togglePlayPause")
end)
prev:subscribe("mouse.clicked", function()
	poll_after("nowplaying-cli previous")
end)
next_btn:subscribe("mouse.clicked", function()
	poll_after("nowplaying-cli next")
end)

poll()
