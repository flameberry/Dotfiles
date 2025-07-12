-- Left floating section of the bar
require("items.apple")
local spaces = require("items.spaces_simple")
require("items.front_app")

table.insert(spaces, "apple")
-- table.insert(spaces, "front_app_arrow")
-- table.insert(spaces, "front_app")

require("utils")
menubar_section(spaces)
print(spaces)

-- Right floating section of the bar
require("items.calendar")
require("items.widgets")
require("items.media")

-- Right Bracket
local items = {
	"widgets.cpu",
	"widgets.volume1",
	"widgets.volume2",
	"widgets.wifi.bracket",
	"widgets.battery",
	"widgets.calendar",
}

menubar_section(items)
