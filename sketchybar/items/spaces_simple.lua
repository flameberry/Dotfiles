local colors = require("colors")
local settings = require("settings")

function parse_string_to_table(s)
	local result = {}
	for line in s:gmatch("([^\n]+)") do
		table.insert(result, line)
	end
	return result
end

local file = io.popen("aerospace list-workspaces --all")
local result = file:read("*a")
file:close()

local workspaces = parse_string_to_table(result)
for i, workspace in ipairs(workspaces) do
	local space = sbar.add("item", "space." .. i, {
		icon = {
			font = { family = settings.font },
			string = workspace,
			color = colors.white,
			highlight_color = colors.yellow,
			padding_right = 12,
			y_offset = 1,
		},
		label = { drawing = false },
		padding_left = 1,
		padding_right = 1,

		click_script = "aerospace workspace " .. i,
	})

	space:subscribe("aerospace_workspace_change", function(env)
		local selected = env.FOCUSED_WORKSPACE == workspace
		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
			background = { border_color = selected and colors.white or colors.bg2 },
		})
	end)
end
