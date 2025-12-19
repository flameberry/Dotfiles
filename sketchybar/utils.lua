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

	bracket:subscribe("mouse.entered", function()
		sbar.animate("tanh", 10, function()
			bracket:set({
				background = {
					border_color = colors.white,
					color = colors.with_alpha(colors.white, 0.1),
				},
			})
		end)
	end)

	bracket:subscribe("mouse.exited", function()
		sbar.animate("tanh", 10, function()
			bracket:set({
				background = {
					border_color = colors.bar.border,
					color = colors.bar.bg,
				},
			})
		end)
	end)
end
