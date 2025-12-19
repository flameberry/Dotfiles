local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local disk = sbar.add("item", "widgets.disk", {
  position = "right",
  icon = { string = icons.disk },
  label = { font = { family = settings.font.numbers } },
  update_freq = 60,
  padding_right = settings.paddings,
})

disk:subscribe({ "routine", "forced" }, function()
  sbar.exec("df -H / | awk 'NR==2 {print $5}'", function(out)
    disk:set({ label = out:gsub("\n", "") })
  end)
end)

return disk
