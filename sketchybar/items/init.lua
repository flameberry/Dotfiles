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

-- require("items.widgets.cpu")
-- menubar_section({ "widgets.cpu" })
--
-- sbar.add("item", { position = "right", width = 6 })
