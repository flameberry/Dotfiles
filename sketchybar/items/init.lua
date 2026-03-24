-- Left section
require("items.apple")
require("items.spaces")

-- Center section
require("items.media")

-- Right section (Order: right to left)
-- Adding items in reverse order of their appearance from left to right.
require("items.calendar")       -- Adds widgets.calendar (Date) then widgets.time (Time)
require("items.widgets.cpu")    -- Adds widgets.cpu
require("items.widgets.ram")    -- Adds widgets.ram
require("items.widgets.battery")-- Adds widgets.battery
require("items.widgets.wifi")   -- Adds widgets.network (Network speed)
