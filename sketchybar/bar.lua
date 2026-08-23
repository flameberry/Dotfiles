local colors = require("colors")

LAYOUT_FULL = true

-- Corner radius of the bar itself, exported so the item brackets in
-- items/init.lua can match it. A bracket rounder than its container reads as a
-- separate shape floating on the bar rather than a panel inset into it.
BAR_CORNER_RADIUS = LAYOUT_FULL and 8 or 0

sbar.bar({
	topmost = "window",
	height = 32,
	-- Full layout paints the bar itself; the floating layout leaves the bar
	-- invisible and lets the item brackets carry the background. Both pull from
	-- the active theme so switching themes actually moves the bar colour.
	color = LAYOUT_FULL and colors.bar.bg or colors.transparent,
	border_width = 0, -- set to 1 to make border_color visible
	border_color = colors.bar.border,
	-- Themes opt into the frosted look by setting bar.blur; those without it
	-- (and the floating layout, which has no bar background to blur) get 0.
	blur_radius = LAYOUT_FULL and (colors.bar.blur or 0) or 0,
	shadow = LAYOUT_FULL,
	position = "top",
	sticky = true,
	padding_right = 0,
	padding_left = 0,
	y_offset = LAYOUT_FULL and 8 or 6,
	margin = 128,
	corner_radius = BAR_CORNER_RADIUS,
})
