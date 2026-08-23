local colors = require("colors")

local M = {}

-- sketchybar has no built-in hover state, so every clickable item needs explicit
-- mouse.entered / mouse.exited handlers. Two idioms, because items fall into two
-- groups:
--
--   hover_lift     — items with no background of their own (apple logo, battery,
--                    media controls). Hover paints a faint chip behind them.
--   hover_brighten — items that already have a background. Hover lifts that
--                    existing colour toward white, so the pill keeps its exact
--                    shape and only its brightness changes.
--
-- Items whose background colour is *state* (the workspace pills: accent when
-- focused, bg2 otherwise) can't use hover_brighten directly, because the state
-- logic writes the same property. Those own their hover locally — see spaces.lua,
-- which brightens whatever the pill's current state colour happens to be.
--
-- mouse.exited.global is subscribed alongside mouse.exited: exited alone is
-- missed when the pointer leaves the bar quickly, which would strand an item in
-- its hover state.

local LIFT_HEIGHT = 24
local LIFT_RADIUS = 12

local function on_hover(item, apply)
	item:subscribe("mouse.entered", function()
		apply(true)
	end)
	item:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
		apply(false)
	end)
end

function M.hover_lift(item, opts)
	opts = opts or {}
	local height = opts.height or LIFT_HEIGHT
	local radius = opts.corner_radius or LIFT_RADIUS

	on_hover(item, function(on)
		item:set({
			background = {
				drawing = true,
				color = on and colors.hover or colors.transparent,
				height = height,
				corner_radius = radius,
			},
		})
	end)
end

-- base is the item's normal background colour; hover lifts it toward white.
function M.hover_brighten(item, base)
	local lit = colors.brighten(base, colors.hover_amount)

	on_hover(item, function(on)
		item:set({ background = { drawing = true, color = on and lit or base } })
	end)
end

return M
