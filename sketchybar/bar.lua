local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 30,
	color = "transparent",
	border_color = colors.bar.border,
	border_width = 0.0,
	shadow = false,
	position = "top",
	sticky = true,
	padding_right = 0,
	padding_left = 0,
	y_offset = 10,
	margin = 15,
	blur_radius = 20,
	corner_radius = 15,
})
