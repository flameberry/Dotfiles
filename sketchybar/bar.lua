local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 30,
	color = colors.bar.bg,
	border_color = colors.bar.border,
	border_width = 0.0,
	shadow = false,
	position = "top",
	sticky = true,
	padding_right = 10,
	padding_left = 10,
	y_offset = 10,
	margin = 15,
	blur_radius = 20,
	corner_radius = 15,
})
