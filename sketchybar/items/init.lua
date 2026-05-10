local colors = require("colors")

-- ──────────────────────────── LEFT ────────────────────────────
require("items.apple")
require("items.spaces")

-- ──────────────── CENTER — LEFT of notch ──────────────────────
require("items.media")

-- Invisible spacer that covers the MacBook Pro notch.
-- Adjust 'width' if items bleed under the notch:
--   14" MBP default res  → try 200–220
--   16" MBP default res  → try 220–250
sbar.add("item", "center.notch", {
	position = "center",
	width = 210,
	icon = { drawing = false },
	label = { drawing = false },
	background = { color = colors.transparent },
})

-- ──────────────── CENTER — RIGHT of notch ─────────────────────
require("items.calendar")

-- ─────────────────────────── RIGHT ────────────────────────────
require("items.widgets.battery")
require("items.widgets.wifi")

-- ══════════════════════════════════════════════════════════════
-- BRACKETS — drawn after all items are created
-- ══════════════════════════════════════════════════════════════

-- Left pill: Apple logo + Aerospace workspaces
sbar.add("bracket", "bracket.left", { "apple.logo", "/space\\..*/", "spaces.right_pad" }, {
	background = {
		color = colors.bg1,
		corner_radius = 16,
		height = 28,
		border_width = 0,
	},
})

-- Center notch pill: media — [notch] — time + date
-- The pill background spans both halves; the notch hardware creates the visual gap.
sbar.add("bracket", "bracket.center", {
	"center.media",
	"center.notch",
	"center.time",
	"center.date",
}, {
	background = {
		color = colors.bg1,
		corner_radius = 16,
		height = 28,
		border_width = 0,
	},
})

-- Right pill: WiFi + Battery
sbar.add("bracket", "bracket.right", { "/widgets\\.network.*/", "widgets.battery" }, {
	background = {
		color = colors.bg1,
		corner_radius = 16,
		height = 28,
		border_width = 0,
	},
})
