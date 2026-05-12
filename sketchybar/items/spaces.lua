local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Horizontal padding (in px) on each side of a space pill. Tweak to change pill widths.
local pill_padding = {
	inactive = 14, -- small dark ovals (no apps + not focused)
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
local space_state = {}
local space_drawn = {}
-- Coalesce rapid events: if an update arrives while one is in-flight, mark
-- dirty and re-run after — never drop. Dropping caused the bracket to settle
-- to a stale state on rapid switches; overlapping animations on top of that
-- caused the pill bg to flicker mid-resize.
local update_in_flight = false
local update_dirty = false

local function build_space_set(icons, selected)
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

	return {
		drawing = should_draw,
		label = {
			string = selected and has_icons and icons or "",
			color = colors.base,
			drawing = has_icons,
			padding_left = 0,
			padding_right = has_icons and pad or 0,
			y_offset = label_y,
		},
		icon = {
			string = "",
			drawing = true,
			padding_left = pad,
			padding_right = has_icons and 0 or pad,
		},
		background = {
			color = selected and colors.accent or colors.bg2,
		},
	}
end

local function update_all_spaces()
	if update_in_flight then
		update_dirty = true
		return
	end
	update_in_flight = true

	sbar.exec(
		"aerospace list-windows --all --format '%{workspace}|%{app-name}' && echo '---' && aerospace list-workspaces --focused",
		function(output)
			update_in_flight = false

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

			local changed = {}
			for ws, space in pairs(space_items) do
				local icons = workspace_icons[ws] or ""
				local selected = ws == focused
				local key = (selected and "1|" or "0|") .. icons
				if space_state[ws] ~= key then
					local was_drawn = space_drawn[ws] or false
					local now_drawn = selected or icons ~= ""
					space_state[ws] = key
					space_drawn[ws] = now_drawn
					changed[#changed + 1] = {
						space = space,
						icons = icons,
						selected = selected,
						drawing_flipped = was_drawn ~= now_drawn,
					}
				end
			end

			if #changed > 0 then
				-- Layout changes (drawing, padding, label.string) apply instantly
				-- so the bracket bg never gets caught half-resized when a second
				-- switch arrives mid-animation. The accent ↔ bg2 background color
				-- still animates so the active-state swap reads as smooth.
				-- Skip the color animation when drawing flipped — animating from
				-- the prior color to accent on a workspace that just appeared
				-- causes a visible bg2 flash on the first frame.
				local to_animate = {}
				for _, c in ipairs(changed) do
					local props = build_space_set(c.icons, c.selected)
					if c.drawing_flipped then
						c.space:set(props)
					else
						local target_color = props.background.color
						props.background = nil
						c.space:set(props)
						to_animate[#to_animate + 1] = { space = c.space, color = target_color }
					end
				end
				if #to_animate > 0 then
					sbar.animate("tanh", 8, function()
						for _, t in ipairs(to_animate) do
							t.space:set({ background = { color = t.color } })
						end
					end)
				end
			end

			if update_dirty then
				update_dirty = false
				update_all_spaces()
			end
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
			color = colors.bg2,
			corner_radius = 16,
			height = 19,
		},
		padding_left = 6,
		padding_right = 0,
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
})

observer:subscribe({ "aerospace_workspace_change", "front_app_switched" }, function(env)
	update_all_spaces()
end)

update_all_spaces()

return space_names
