-- Left floating section of the bar
require("items.apple")
local spaces = require("items.spaces_simple")
require("items.front_app")

-- Assemble the left section in order
local left_section = { "apple.logo" }

-- Add spaces items
for _, space_name in ipairs(spaces) do
	table.insert(left_section, space_name)
end

-- Add a separator before front app
sbar.add("item", "left_separator", {
	width = 10,
})
table.insert(left_section, "left_separator")

-- Add front app
table.insert(left_section, "front_app_text")

require("utils")
menubar_section(left_section)

require("utils")

-- Right floating section of the bar (Added from right to left)
require("items.calendar")
menubar_section({ "widgets.calendar" })

sbar.add("item", { position = "right", width = 6 })

require("items.widgets.battery")
menubar_section({ "widgets.battery" })

sbar.add("item", { position = "right", width = 6 })

require("items.widgets.wifi")
menubar_section({ "widgets.wifi.padding", "widgets.wifi1", "widgets.wifi2" })

sbar.add("item", { position = "right", width = 6 })

require("items.widgets.ethernet")
menubar_section({ "widgets.ethernet.padding", "widgets.ethernet1", "widgets.ethernet2" })

sbar.add("item", { position = "right", width = 6 })

require("items.widgets.volume")
menubar_section({ "widgets.volume2", "widgets.volume1" })

sbar.add("item", { position = "right", width = 6 })