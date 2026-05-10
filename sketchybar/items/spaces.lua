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

					local has_icons = icons ~= ""
					space:set({
						drawing = should_draw,
						label = {
							string = has_icons and icons or "",
							color = selected and colors.base or colors.white,
							drawing = has_icons,
						},
						icon = {
							color = selected and colors.base or colors.white,
							padding_left = has_icons and 12 or 9,
							padding_right = has_icons and 6 or 9,
						},
						background = {
							color = selected and colors.accent or colors.with_alpha(colors.white, 0.08),
							height = 24,
							corner_radius = 12,
						},
					})
				end
			end)
		end
	)
end

local workspaces = exec_to_table("aerospace list-workspaces --all")

for i, workspace in ipairs(workspaces) do
	local space = sbar.add("item", "space." .. workspace:gsub("%s+", "_"), {
		icon = {
			font = { family = settings.font.text, style = settings.font.style_map["Bold"], size = 12 },
			string = workspace,
			color = colors.white,
			padding_left = 12,
			padding_right = 6,
			y_offset = 0,
		},
		label = {
			string = "",
			font = "sketchybar-app-font:Regular:14.0",
			color = colors.white,
			padding_right = 12,
			y_offset = -1,
			drawing = false,
		},
		background = {
			color = colors.with_alpha(colors.white, 0.1),
			corner_radius = 12,
			height = 24,
		},
		padding_left = 2,
		padding_right = 2,
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
