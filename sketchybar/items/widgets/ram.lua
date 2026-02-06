local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("item", "widgets.ram", {
  position = "right",
  icon = {
    string = icons.memory,
    color = colors.iris,
  },
  label = { font = { family = settings.font.numbers } },
  update_freq = 10,
  padding_right = settings.paddings,
})

ram:subscribe({ "routine", "forced" }, function()
  sbar.exec("memory_pressure | grep 'System-wide memory free percentage:' | awk '{ print 100-$5 }'", function(out)
    ram:set({ label = out:gsub("\n", "") .. "%" })
  end)
end)

return ram
