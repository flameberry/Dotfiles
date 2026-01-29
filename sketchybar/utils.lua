local colors = require("colors")

function menubar_section(items)
	local bracket = sbar.add("bracket", items, {
		background = {
			color = colors.bar.bg,
			corner_radius = 13,
			height = 28,
			border_width = 1,
			border_color = colors.bar.border,
		},
	})
end
