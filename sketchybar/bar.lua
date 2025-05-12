local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 32,
	color = colors.bar.bg,
	shadow = false,
	position = "top",
	sticky = true,
	padding_right = 8,
	padding_left = 8,
	y_offset = 6,
	margin = 8,
	blur_radius = 20,
	corner_radius = 32,
	notch_width = 30,
})
