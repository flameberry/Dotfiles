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

		-- bar = { bg = 0xff1f1d2e, border = 0xff26233a },
		bar = { bg = 0xf00b0a10, border = 0xff26233a },

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
}

-- Select the active theme here
local active_theme = "rose_pine" -- options: "catppuccin", "rose_pine", "rose_pine_moon"

local theme = themes[active_theme]

theme.with_alpha = function(color, alpha)
	if alpha > 1.0 or alpha < 0.0 then
		return color
	end
	return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

return theme
