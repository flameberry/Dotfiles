local colors = require("colors")
local settings = require("settings")

-- Function to execute a command and return its output as a table of lines
local function exec_to_table(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	local lines = {}
	for line in result:gmatch("[^\n]+") do
		lines[#lines + 1] = line
	end
	return lines
end

-- Get all workspaces and focused workspace in one go
local workspaces = exec_to_table("aerospace list-workspaces --all")
local focused_workspace = exec_to_table("aerospace list-workspaces --focused")[1]

local spaces = {}
for i, workspace in ipairs(workspaces) do
	local is_focused = workspace == focused_workspace

	local space = sbar.add("item", "space." .. i, {
		icon = {
			font = { family = settings.font },
			string = workspace,
			color = is_focused and colors.black or colors.white,
			padding_left = 8,
			padding_right = 8,
			-- y_offset = 1,
		},
		background = {
			color = is_focused and colors.accent or colors.transparent,
			corner_radius = 20,
			height = 20,
		},
		label = { drawing = false },
		padding_left = 1,
		padding_right = (i == #workspaces) and 8 or 1,
		click_script = "aerospace workspace " .. workspace,
	})

	spaces[i] = space.name

	-- Respond to workspace changes
	space:subscribe("aerospace_workspace_change", function(env)
		local selected = env.FOCUSED_WORKSPACE == workspace
		sbar.animate("tanh", 8, function()
			space:set({
				icon = {
					color = selected and colors.black or colors.white,
				},
				background = {
					color = selected and colors.accent or colors.transparent,
				},
			})
		end)
	end)
end

return spaces
