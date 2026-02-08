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

local space_items = {}
local space_names = {}
local workspace_colors = {}

-- Define a sequence of Rose Pine colors for spaces
local palette = {
	colors.gold,
	colors.love,
	colors.pine,
	colors.rose,
	colors.iris,
	colors.foam,
	colors.yellow,
	colors.magenta,
}

local function update_all_spaces()
	sbar.exec(
		"aerospace list-windows --all --format '%{workspace}|%{app-name}' && echo '---' && aerospace list-workspaces --focused",
		function(output)
			local workspace_icons = {}
			local seen = {}
			local focused = ""
			local parsing_windows = true

			for line in output:gmatch("[^\n]+") do
				if line == "---" then
					parsing_windows = false
				elseif parsing_windows then
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
				else
					focused = line:gsub("%s+", "")
				end
			end

			sbar.animate("tanh", 8, function()
				for ws, space in pairs(space_items) do
					local icons = workspace_icons[ws] or ""
					local selected = ws == focused
					local should_draw = selected or icons ~= ""
					local color = workspace_colors[ws] or colors.white

					space:set({
						drawing = should_draw,
						label = {
							string = icons ~= "" and icons or " —",
							color = selected and color or colors.with_alpha(color, 0.7),
						},
						icon = {
							color = selected and color or colors.with_alpha(color, 0.7),
						},
						background = {
							color = selected and colors.with_alpha(color, 0.1) or colors.transparent,
							border_color = selected and colors.with_alpha(color, 0.2) or colors.transparent,
							border_width = selected and 1 or 0,
						},
					})
				end
			end)
		end
	)
end

local workspaces = exec_to_table("aerospace list-workspaces --all")

for i, workspace in ipairs(workspaces) do
	local color = palette[(i - 1) % #palette + 1]
	workspace_colors[workspace] = color

	local space = sbar.add("item", "space." .. workspace:gsub("%s+", "_"), {
		icon = {
			font = { family = settings.font.text },
			string = workspace,
			color = colors.with_alpha(color, 0.7),
			padding_left = 8,
			padding_right = 2,
			y_offset = 1,
		},
		label = {
			string = " —",
			font = "sketchybar-app-font:Regular:16.0",
			color = colors.with_alpha(color, 0.7),
			padding_left = 2,
			padding_right = 8,
			y_offset = -1,
			drawing = true,
		},
		background = {
			color = colors.transparent,
			corner_radius = 20,
			height = 20,
			border_width = 0,
		},
		padding_left = 1,
		padding_right = 1,
		drawing = false,
		click_script = 'aerospace workspace "' .. workspace .. '"',
	})

	space_items[workspace] = space
	space_names[i] = space.name
end

local observer = sbar.add("item", {
	drawing = false,
	updates = true,
	update_freq = 5,
})

observer:subscribe({ "aerospace_workspace_change", "front_app_switched", "routine" }, function(env)
	update_all_spaces()
end)

update_all_spaces()

return space_names
