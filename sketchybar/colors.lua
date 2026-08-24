local themes = {
	catppuccin = {
		base = 0xff1e1e2e,
		surface = 0xff313244,
		overlay = 0xff45475a,
		muted = 0xff6c7086,
		subtle = 0xff9399b2,
		text = 0xffcdd6f4,
		love = 0xfff38ba8,
		gold = 0xfff9e2af,
		rose = 0xfff5e0dc,
		pine = 0xff94e2d5,
		foam = 0xff89dceb,
		iris = 0xffcba6f7,
		highlight_low = 0xff181825,
		highlight_med = 0xff11111b,
		highlight_high = 0xff313244,

		black = 0xff181926,
		white = 0xffcad3f5,
		red = 0xffed8796,
		green = 0xffa6da95,
		blue = 0xff8aadf4,
		yellow = 0xffeed49f,
		orange = 0xfff5a97f,
		magenta = 0xffc6a0f6,
		grey = 0xff939ab7,
		transparent = 0x00000000,
		accent = 0xffeed49f,

		bar = { bg = 0xff181926, border = 0xff45475a },
		popup = { bg = 0xf0181926, border = 0xff45475a },
		bg1 = 0x60000000,
		bg2 = 0x90000000,
	},
	rose_pine = {
		base = 0xff191724,
		surface = 0xff1f1d2e,
		overlay = 0xff26233a,
		muted = 0xff6e6a86,
		subtle = 0xff908caa,
		text = 0xffe0def4,
		love = 0xffeb6f92,
		gold = 0xfff6c177,
		rose = 0xffebbcba,
		pine = 0xff31748f,
		foam = 0xff9ccfd8,
		iris = 0xffc4a7e7,
		highlight_low = 0xff21202e,
		highlight_med = 0xff403d52,
		highlight_high = 0xff524f67,

		black = 0xff191724,
		white = 0xffe0def4,
		red = 0xffeb6f92,
		green = 0xff31748f,
		blue = 0xff9ccfd8,
		yellow = 0xfff6c177,
		orange = 0xffebbcba,
		magenta = 0xffc4a7e7,
		grey = 0xff6e6a86,
		transparent = 0x00000000,
		accent = 0xffebbcba,

		bar = { bg = 0xcc0b0a10, border = 0xff26233a },
		popup = { bg = 0xf01f1d2e, border = 0xff26233a },
		bg1 = 0x601f1d2e,
		bg2 = 0x901f1d2e,
	},
	rose_pine_moon = {
		base = 0xff232136,
		surface = 0xff2a273f,
		overlay = 0xff393552,
		muted = 0xff6e6a86,
		subtle = 0xff908caa,
		text = 0xffe0def4,
		love = 0xffeb6f92,
		gold = 0xfff6c177,
		rose = 0xffea9a97,
		pine = 0xff3e8fb0,
		foam = 0xff9ccfd8,
		iris = 0xffc4a7e7,
		highlight_low = 0xff2a283e,
		highlight_med = 0xff44415a,
		highlight_high = 0xff56526e,

		black = 0xff232136,
		white = 0xffe0def4,
		red = 0xffeb6f92,
		green = 0xff3e8fb0,
		blue = 0xff9ccfd8,
		yellow = 0xfff6c177,
		orange = 0xffea9a97,
		magenta = 0xffc4a7e7,
		grey = 0xff6e6a86,
		transparent = 0x00000000,
		accent = 0xffea9a97,

		bar = { bg = 0xd02a273f, border = 0xff393552 },
		popup = { bg = 0xf02a273f, border = 0xff393552 },
		bg1 = 0x602a273f,
		bg2 = 0x902a273f,
	},
	neon = {
		base = 0xff1e1e2e,
		surface = 0xff313244,
		overlay = 0xff45475a,
		muted = 0xff6c7086,
		subtle = 0xff9399b2,
		text = 0xffffffff,
		love = 0xfff38ba8,
		gold = 0xfff9e2af,
		rose = 0xfff5e0dc,
		pine = 0xff94e2d5,
		foam = 0xff89dceb,
		iris = 0xffcba6f7,
		highlight_low = 0xff181825,
		highlight_med = 0xff11111b,
		highlight_high = 0xff313244,

		black = 0xff11111b,
		white = 0xffffffff,
		red = 0xfff38ba8,
		green = 0xffa6e3a1,
		blue = 0xff89b4fa,
		yellow = 0xfff9e2af,
		orange = 0xfffab387,
		magenta = 0xffcba6f7,
		grey = 0xff6c7086,
		transparent = 0x00000000,
		accent = 0xffcba6f7,

		bar = { bg = 0xff11111b, border = 0xffcba6f7 },
		popup = { bg = 0xff11111b, border = 0xffcba6f7 },
		bg1 = 0x33ffffff,
		bg2 = 0x55ffffff,
	},
	-- Dark blue-black base with sakura-pink accent — tuned to the Sakura.png wallpaper.
	aurora = {
		base = 0xff0f1117,
		surface = 0xff151920,
		overlay = 0xff1e2330,
		muted = 0xff3d4560,
		subtle = 0xff6b7299,
		text = 0xffeef0f7,
		love = 0xffeb6f92,
		gold = 0xfff4d4b0,
		rose = 0xffeb96b9,
		pine = 0xff5dc4c2,
		foam = 0xffa8d2e8,
		iris = 0xffa89bc7,
		highlight_low = 0xff0a0c12,
		highlight_med = 0xff1a1e28,
		highlight_high = 0xff252c3d,

		black = 0xff0f1117,
		white = 0xffeef0f7,
		red = 0xffeb6f92,
		green = 0xff8bc454,
		blue = 0xffa8d2e8,
		yellow = 0xfff4d4b0,
		orange = 0xffe89572,
		magenta = 0xffa89bc7,
		grey = 0xff3d4560,
		transparent = 0x00000000,
		accent = 0xffeb96b9,

		bar = { bg = 0xff0f1117, border = 0xff252c3d },
		popup = { bg = 0xff0f1117, border = 0xffeb96b9 },
		-- bg1 = 0xff0f1117,
		-- bg1 = 0xff040c0c,
		bg1 = 0xff000000,
		bg2 = 0xff1b1824,
		bg3 = 0xff221d2e,
	},
	-- Crimson red base with cyan accent — tuned to the Gojo (JJK) wallpaper.
	gojo = {
		base = 0xff0a0606,
		surface = 0xff140a0a,
		overlay = 0xff1f1414,
		muted = 0xff5a3030,
		subtle = 0xff8a5050,
		text = 0xfff5ebe0,
		love = 0xffe63946,
		gold = 0xfff4c95d,
		rose = 0xffe85a6e,
		pine = 0xff4ec6e0,
		foam = 0xff7ddfff,
		iris = 0xffd97aaa,
		highlight_low = 0xff080404,
		highlight_med = 0xff1a0e0e,
		highlight_high = 0xff2a1414,

		black = 0xff0a0606,
		white = 0xfff5ebe0,
		red = 0xffe63946,
		green = 0xff8ac35a,
		blue = 0xff4ec6e0,
		yellow = 0xfff4c95d,
		orange = 0xffe87655,
		magenta = 0xffd97aaa,
		grey = 0xff5a3030,
		transparent = 0x00000000,
		accent = 0xffe63946,

		-- Fully opaque: black bar, no transparency anywhere.
		--
		-- blur stays 0 and should not be re-enabled. sketchybar 2.24's
		-- blur_radius does not clip to the bar — measured against an unblurred
		-- capture it bleeds ~26pt below the bar at radius 40 and still ~17pt at
		-- radius 8, and upward into the y_offset gap as well. A flush bar
		-- (y_offset/margin/corner_radius all 0) bleeds the same 26pt, so the blur
		-- region itself is oversized rather than the floating geometry being at
		-- fault. Any non-zero value smears the wallpaper in a band under the bar.
		--
		-- bg1 (bracket.left / bracket.right) is intentionally transparent: the
		-- outer two groups sit directly on the black bar with no panel behind
		-- them, so only the workspace pills and the center media bracket carry
		-- fill. Set it to 0xff140a0a to bring the side panels back.
		bar = { bg = 0xff000000, border = 0xff2a1414, blur = 0 },
		popup = { bg = 0xff0a0606, border = 0xffe63946 },
		-- Focused workspace pill. Deliberately much darker than `accent`: accent
		-- is used as a *foreground* colour elsewhere (weather, media, calendar)
		-- where it has to stay bright against the black bar, so the pill gets its
		-- own deep oxblood instead of dragging accent down with it. Foreground on
		-- this pill is `text`, not `base` — near-black on this fill measures
		-- ~2.4:1, well under legible, while `text` sits around 9:1.
		space_active = 0xff5c1019,
		bg1 = 0x00000000,
		bg2 = 0xff200a0a,
		bg3 = 0xff2a0a0a,
	},
}

-- Select the active theme here
local active_theme = "gojo" -- options: "catppuccin", "rose_pine", "rose_pine_moon", "neon", "aurora", "gojo"

local theme = themes[active_theme]

-- Only the gojo theme defines a dedicated focused-workspace colour; every other
-- theme keeps the old behaviour of reusing its accent for that pill.
theme.space_active = theme.space_active or theme.accent
theme.space_active_fg = theme.space_active_fg or (theme.space_active == theme.accent and theme.base or theme.text)

theme.with_alpha = function(color, alpha)
	if alpha > 1.0 or alpha < 0.0 then
		return color
	end
	return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

-- Blend a colour toward white, preserving alpha. Used for hover states: an item
-- that already has a background lights that background up rather than growing a
-- border, so the pill keeps its shape and only its brightness changes.
theme.brighten = function(color, amount)
	local a = color & 0xff000000
	local r = (color >> 16) & 0xff
	local g = (color >> 8) & 0xff
	local b = color & 0xff
	r = math.floor(r + (255 - r) * amount)
	g = math.floor(g + (255 - g) * amount)
	b = math.floor(b + (255 - b) * amount)
	return a | (r << 16) | (g << 8) | b
end

-- How far a hovered background is lifted toward white.
theme.hover_amount = 0.22

-- Hover chip for items that have no background of their own to brighten.
theme.hover = theme.with_alpha(theme.white, 0.14)

return theme
