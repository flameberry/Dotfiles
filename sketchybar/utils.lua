local colors = require("colors")

function menubar_section(items)
	sbar.add("bracket", items, {
		background = {
			color = colors.bar.bg,
			corner_radius = 32,
			height = 32,
			-- border_width = 1,
			-- border_color = colors.accent,
		},
	})
end
