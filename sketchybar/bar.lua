local colors = require("colors")

LAYOUT_FULL = true

sbar.bar({
	topmost = "window",
	height = 32,
	-- Full layout paints the bar itself; the floating layout leaves the bar
	-- invisible and lets the item brackets carry the background. Both pull from
	-- the active theme so switching themes actually moves the bar colour.
	color = LAYOUT_FULL and colors.bar.bg or colors.transparent,
	border_width = 0, -- set to 1 to make border_color visible
	border_color = colors.bar.border,
	shadow = LAYOUT_FULL,
	position = "top",
	sticky = true,
	padding_right = 0,
	padding_left = 0,
	y_offset = LAYOUT_FULL and 8 or 6,
	margin = 128,
	blur_radius = 0,
	corner_radius = LAYOUT_FULL and 8 or 0,
})
