local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

-- For position="center", earlier-added items render to the LEFT.
-- Bar layout: playpause → artwork → title

local playpause = sbar.add("item", "center.media.playpause", {
	position = "center",
	icon = {
		string = icons.media.play,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 13,
		},
		color = colors.with_alpha(colors.accent, 0.45),
		padding_left = 14,
		padding_right = 4,
	},
	label = { drawing = false },
	click_script = "nowplaying-cli togglePlayPause",
})

local artwork = sbar.add("item", "center.media.artwork", {
	position = "center",
	background = {
		image = {
			string = "",
			scale = 0.5,
			corner_radius = 4,
		},
		color = colors.transparent,
		border_width = 0,
		height = 22,
		corner_radius = 4,
	},
	icon = { drawing = false },
	label = { drawing = false },
	drawing = false,
	padding_left = 4,
	padding_right = 2,
})

local media = sbar.add("item", "center.media", {
	position = "center",
	icon = { drawing = false },
	scroll_texts = false,
	label = {
		string = "nothing playing",
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 12,
		},
		color = colors.with_alpha(colors.white, 0.30),
		padding_left = 4,
		padding_right = 14,
		max_chars = 24,
	},
	popup = {
		align = "center",
		horizontal = true,
		background = {
			color = colors.popup.bg,
			corner_radius = 9,
			border_width = 1,
			border_color = colors.popup.border,
			height = 32,
		},
	},
	update_freq = 3,
	updates = true,
})

local popup_prev = sbar.add("item", "popup.center.media.prev", {
	position = "popup.center.media",
	icon = {
		string = icons.media.back,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 14,
		},
		color = colors.with_alpha(colors.accent, 0.85),
		padding_left = 12,
		padding_right = 8,
	},
	label = { drawing = false },
	click_script = "nowplaying-cli previous",
})

local popup_playpause = sbar.add("item", "popup.center.media.playpause", {
	position = "popup.center.media",
	icon = {
		string = icons.media.play,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 14,
		},
		color = colors.accent,
		padding_left = 8,
		padding_right = 8,
	},
	label = { drawing = false },
	click_script = "nowplaying-cli togglePlayPause",
})

local popup_next = sbar.add("item", "popup.center.media.next", {
	position = "popup.center.media",
	icon = {
		string = icons.media.forward,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 14,
		},
		color = colors.with_alpha(colors.accent, 0.85),
		padding_left = 8,
		padding_right = 12,
	},
	label = { drawing = false },
	click_script = "nowplaying-cli next",
})

local current_track_key = nil
local artwork_counter = 0
local last_label_state = nil
local last_play_state = nil

local function update_artwork(title, artist)
	local key = (title or "") .. "|" .. (artist or "")
	if key == current_track_key then
		return
	end
	current_track_key = key

	artwork_counter = artwork_counter + 1
	local path = string.format("/tmp/sketchybar_art_%d.jpg", artwork_counter)
	local cmd = string.format(
		"nowplaying-cli get artworkData 2>/dev/null | base64 -D > %q 2>/dev/null; "
			.. "if [ -s %q ]; then sips -Z 44 %q >/dev/null 2>&1; echo ok; else rm -f %q; fi",
		path,
		path,
		path,
		path
	)
	sbar.exec(cmd, function(out)
		if current_track_key ~= key then
			return
		end
		if out and out:match("ok") then
			artwork:set({
				drawing = true,
				background = { image = { string = path } },
			})
		else
			artwork:set({ drawing = false })
		end
	end)
end

local function clear_artwork()
	current_track_key = nil
	artwork:set({ drawing = false })
end

local function set_play_icon(playing)
	if playing == last_play_state then
		return
	end
	last_play_state = playing
	local glyph = playing and icons.media.pause or icons.media.play
	local color = playing and colors.accent or colors.with_alpha(colors.accent, 0.45)
	playpause:set({ icon = { string = glyph, color = color } })
	popup_playpause:set({ icon = { string = glyph } })
end

local function set_label(text, faded, animate)
	local key = (faded and "f|" or "n|") .. text
	if key == last_label_state then
		return
	end
	last_label_state = key
	local color = faded and colors.with_alpha(colors.white, faded) or colors.white
	if animate then
		sbar.animate("tanh", 10, function()
			media:set({ label = { string = text, color = color } })
		end)
	else
		media:set({ label = { string = text, color = color } })
	end
end

local function set_idle()
	clear_artwork()
	set_play_icon(false)
	set_label("nothing playing", 0.30, true)
end

local function set_track(title, artist, playing)
	local display = (artist ~= "" and (artist .. " – ") or "") .. title

	update_artwork(title, artist)
	set_play_icon(playing)
	set_label(display, playing and false or 0.45, true)
end

local function poll()
	sbar.exec("nowplaying-cli get playbackRate title artist", function(out)
		local rate_str, title, artist = out:match("([^\n]*)\n([^\n]*)\n([^\n]*)")
		local rate = tonumber(rate_str) or 0
		title = title and title:gsub("^%s*(.-)%s*$", "%1") or ""
		artist = artist and artist:gsub("^%s*(.-)%s*$", "%1") or ""

		if title ~= "" and title ~= "null" then
			set_track(title, artist, rate > 0)
		else
			set_idle()
		end
	end)
end

local function poll_after(cmd)
	sbar.exec(cmd, function()
		sbar.exec("sleep 0.3 && true", function()
			poll()
		end)
	end)
end

local function toggle_popup()
	media:set({ popup = { drawing = "toggle" } })
end

media:subscribe({ "routine", "system_woke", "media_change" }, poll)
media:subscribe("mouse.clicked", toggle_popup)
artwork:subscribe("mouse.clicked", toggle_popup)

playpause:subscribe("mouse.clicked", function()
	poll_after("nowplaying-cli togglePlayPause")
end)
popup_prev:subscribe("mouse.clicked", function()
	poll_after("nowplaying-cli previous")
end)
popup_playpause:subscribe("mouse.clicked", function()
	poll_after("nowplaying-cli togglePlayPause")
end)
popup_next:subscribe("mouse.clicked", function()
	poll_after("nowplaying-cli next")
end)

media:subscribe("mouse.exited.global", function()
	media:set({ popup = { drawing = false } })
end)

poll()
