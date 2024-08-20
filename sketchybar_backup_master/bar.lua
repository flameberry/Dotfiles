local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 36,
	color = colors.with_alpha(colors.bar.bg, 1.0),
	padding_right = 4,
	padding_left = 4,
})
