local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Horizontal padding (in px) on each side of a space pill. Tweak to change pill widths.
local pill_padding = {
	inactive = 16, -- small dark ovals (no apps + not focused)
	active_empty = 24, -- focused workspace with no apps
	active_icons = 18, -- focused workspace with apps (padding around the app icons)
}

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
							if workspace_icons[ws] == "" then
								workspace_icons[ws] = icon
							else
								workspace_icons[ws] = workspace_icons[ws] .. " " .. icon
							end
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
					local has_icons = icons ~= ""
					local should_draw = selected or has_icons

					local pad
					if not selected then
						pad = pill_padding.inactive
					elseif has_icons then
						pad = pill_padding.active_icons
					else
						pad = pill_padding.active_empty
					end

					-- The space character between glyphs has different vertical metrics
					-- than the app icons themselves, which shifts multi-icon labels visually.
					-- Compensate only when there is more than one icon.
					local multi_icon = has_icons and icons:find(" ") ~= nil
					local label_y = multi_icon and -1 or 0

					space:set({
						drawing = should_draw,
						label = {
							string = selected and has_icons and icons or "",
							color = colors.base,
							drawing = selected and has_icons,
							padding_left = 0,
							padding_right = selected and has_icons and pad or 0,
							y_offset = label_y,
						},
						icon = {
							string = "",
							drawing = true,
							padding_left = pad,
							padding_right = (selected and has_icons) and 0 or pad,
						},
						background = {
							color = selected and colors.accent or colors.with_alpha(colors.white, 0.18),
							height = 20,
							corner_radius = 10,
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
			string = "",
			color = colors.white,
			padding_left = 9,
			padding_right = 9,
			y_offset = 0,
			drawing = true,
		},
		label = {
			string = "",
			font = "sketchybar-app-font:Regular:14.0",
			color = colors.base,
			padding_left = 0,
			padding_right = 0,
			y_offset = -1,
			drawing = false,
		},
		background = {
			color = colors.with_alpha(colors.white, 0.12),
			corner_radius = 10,
			height = 20,
		},
		padding_left = 2,
		padding_right = 2,
		drawing = false,
		click_script = 'aerospace workspace "' .. workspace .. '"',
	})

	space_items[workspace] = space
	space_names[i] = space.name
end

-- Invisible spacer that extends the left bracket background past the last space,
-- adding visual padding on the right end of the spaces pill.
sbar.add("item", "spaces.right_pad", {
	width = 0,
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
})

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
