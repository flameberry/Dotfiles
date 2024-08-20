local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 38,
	color = colors.bar.bg,
	shadow = true,
	position = "top",
	sticky = true,
	padding_right = 10,
	padding_left = 10,
	y_offset = 8,
	margin = 10,
	blur_radius = 20,
	corner_radius = 9,
	notch_width = 0,
})
