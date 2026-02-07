local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local function exec_to_table(cmd)
	local handle = io.popen(cmd)
	if not handle then
		return {}
	end
	local result = handle:read("*a")
	handle:close()
	local lines = {}
	for line in result:gmatch("[^\n]+") do
		lines[#lines + 1] = line
	end
	return lines
end

local function get_all_icons()
	local windows = exec_to_table("aerospace list-windows --all --format '%{workspace}|%{app-name}'")
	local workspace_icons = {}
	local seen = {}
	for _, line in ipairs(windows) do
		local ws, app = line:match("^(.-)|(.+)$")
		if ws then
			if not workspace_icons[ws] then
				workspace_icons[ws] = ""
				seen[ws] = {}
			end
			local lookup = app_icons[app]
			local icon = ((lookup == nil) and app_icons["default"] or lookup)
			if not seen[ws][icon] then
				workspace_icons[ws] = workspace_icons[ws] .. " " .. icon
				seen[ws][icon] = true
			end
		end
	end
	return workspace_icons
end

local workspaces = exec_to_table("aerospace list-workspaces --all")
local focused_workspace = exec_to_table("aerospace list-workspaces --focused")[1]
local all_icons = get_all_icons()

local space_items = {}
local space_names = {}

for i, workspace in ipairs(workspaces) do
	local is_focused = workspace == focused_workspace
	local icons = all_icons[workspace] or ""
	local has_windows = icons ~= ""

	local space = sbar.add("item", "space." .. workspace, {
		icon = {
			font = { family = settings.font.text },
			string = workspace,
			color = is_focused and colors.base or colors.text,
			padding_left = 8,
			padding_right = 4,
			y_offset = 1,
		},
		label = {
			string = icons ~= "" and icons or " —",
			font = "sketchybar-app-font:Regular:16.0",
			color = is_focused and colors.base or colors.text,
			padding_left = 4,
			padding_right = 10,
			y_offset = -1,
			drawing = true,
		},
		background = {
			color = is_focused and colors.accent or colors.transparent,
			corner_radius = 20,
			height = 20,
		},
		padding_left = 1,
		padding_right = 1,
		drawing = is_focused or has_windows,
		click_script = "aerospace workspace " .. workspace,
	})

	space_items[workspace] = space
	space_names[i] = space.name

	space:subscribe("aerospace_workspace_change", function(env)
		local selected = env.FOCUSED_WORKSPACE == workspace
		local current_icons = get_all_icons()[workspace] or ""
		local should_draw = selected or current_icons ~= ""

		sbar.animate("tanh", 8, function()
			space:set({
				drawing = should_draw,
				icon = {
					color = selected and colors.base or colors.text,
				},
				label = {
					string = current_icons ~= "" and current_icons or " —",
					color = selected and colors.base or colors.text,
				},
				background = {
					color = selected and colors.accent or colors.transparent,
				},
			})
		end)
	end)
end

-- Update icons when front app switches as a proxy for window changes
local front_app_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

front_app_observer:subscribe("front_app_switched", function(env)
	local icons_map = get_all_icons()
	local focused = exec_to_table("aerospace list-workspaces --focused")[1]
	for ws, space in pairs(space_items) do
		local icons = icons_map[ws] or ""
		local selected = ws == focused
		local should_draw = selected or icons ~= ""
		space:set({
			drawing = should_draw,
			label = { string = icons ~= "" and icons or " —" },
		})
	end
end)

-- Periodically refresh to catch window open/close that doesn't trigger other events
local periodic_observer = sbar.add("item", {
	drawing = false,
	update_freq = 5,
})

periodic_observer:subscribe("routine", function(env)
	local icons_map = get_all_icons()
	local focused = exec_to_table("aerospace list-workspaces --focused")[1]
	for ws, space in pairs(space_items) do
		local icons = icons_map[ws] or ""
		local selected = ws == focused
		local should_draw = selected or icons ~= ""
		space:set({
			drawing = should_draw,
			label = { string = icons ~= "" and icons or " —" },
		})
	end
end)

return space_names
