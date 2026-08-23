local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Window manager backend. Swap to spaces_aerospace / spaces_omniwm and restart
-- sketchybar to switch. All modules expose: events, fetch_state_cmd(),
-- click_cmd(id), display_label(id), and optionally ensure_watcher().
-- local backend = require("items.spaces_aerospace")
local backend = require("items.spaces_omniwm")

-- Workspace pills are drawn from a fixed pool of pre-created items rather than
-- one item per workspace discovered at startup.
--
-- Why: sketchybar resolves bracket membership when the bracket is created, and
-- bracket.left is built in items/init.lua during config load. An item added
-- later would render outside the left pill's background. The old code therefore
-- had to know every workspace up front — it ran a blocking io.popen at load and
-- never looked again, so adding or removing an OmniWM workspace left the bar
-- silently wrong until a full sketchybar reload.
--
-- The pool sidesteps both problems: every slot exists (hidden) before the
-- bracket is built, and update_all_spaces reassigns slots to workspaces as the
-- set changes. Slots are handed out in the backend's display order, so a
-- workspace appearing in the middle just shifts the assignments right.
local MAX_SLOTS = 16

-- Height of every pill. Inactive pills are pinned to this width too, so they
-- render as perfect circles.
local pill_height = 19

-- Horizontal padding (in px) on each side of a space pill. Tweak to change pill widths.
-- Inactive pills have no padding — their width is fixed to pill_height instead.
local pill_padding = {
	active_empty = 24, -- focused workspace with no apps
	active_icons = 18, -- focused workspace with apps (padding around the app icons)
}

-- Workspace number color inside an inactive circle (active pills use colors.base
-- on the accent background).
local inactive_number_color = colors.text

-- Gap between the workspace number and the app icons in a focused-with-apps pill.
local number_icon_gap = 6

local slots = {} -- slot index -> sbar item
local slot_ws = {} -- slot index -> workspace id currently shown there (or nil)
local slot_state = {} -- slot index -> last rendered state key
local slot_drawn = {} -- slot index -> whether the pill was visible
local slot_base_color = {} -- slot index -> pill's current *state* bg colour
local slot_hovered = {} -- slot index -> pointer is currently over the pill
-- Coalesce rapid events: if an update arrives while one is in-flight, mark
-- dirty and re-run after — never drop. Dropping caused the bracket to settle
-- to a stale state on rapid switches; overlapping animations on top of that
-- caused the pill bg to flicker mid-resize.
-- Timestamped instead of boolean so a lost sbar.exec callback can't strand
-- the lock; after LOCK_TIMEOUT_S the next event proceeds anyway.
local update_in_flight_at = 0
local update_dirty = false
local LOCK_TIMEOUT_S = 3

local function build_space_set(icons, selected, ws_label)
	local has_icons = icons ~= ""
	local should_draw = selected or has_icons
	local show_number = ws_label ~= nil and ws_label ~= ""

	-- Inactive pill: a circle with just the workspace number in it. The icon is
	-- given a fixed width equal to the pill height (and centered inside it) so
	-- the pill stays square regardless of how wide the number renders.
	if not selected then
		return {
			drawing = should_draw,
			label = {
				string = "",
				drawing = false,
				padding_left = 0,
				padding_right = 0,
			},
			icon = {
				string = show_number and ws_label or "",
				color = inactive_number_color,
				drawing = true,
				width = pill_height,
				align = "center",
				padding_left = 0,
				padding_right = 0,
			},
			background = {
				color = colors.bg2,
			},
		}
	end

	local pad
	if has_icons then
		pad = pill_padding.active_icons
	else
		pad = pill_padding.active_empty
	end

	-- The space character between glyphs has different vertical metrics
	-- than the app icons themselves, which shifts multi-icon labels visually.
	-- Compensate only when there is more than one icon.
	local multi_icon = has_icons and icons:find(" ") ~= nil
	local label_y = multi_icon and -1 or 0

	local icon_padding_right
	if has_icons and show_number then
		icon_padding_right = number_icon_gap
	elseif has_icons then
		icon_padding_right = 0
	else
		icon_padding_right = pad
	end

	-- Active pill: width follows its content, so undo the fixed icon width the
	-- inactive circle sets.
	return {
		drawing = true,
		label = {
			string = has_icons and icons or "",
			color = colors.base,
			drawing = has_icons,
			padding_left = 0,
			padding_right = has_icons and pad or 0,
			y_offset = label_y,
		},
		icon = {
			string = show_number and ws_label or "",
			color = colors.base,
			drawing = true,
			width = "dynamic",
			align = "center",
			padding_left = pad,
			padding_right = icon_padding_right,
		},
		background = {
			color = colors.accent,
		},
	}
end

local function update_all_spaces()
	local now = os.time()
	if update_in_flight_at ~= 0 and (now - update_in_flight_at) < LOCK_TIMEOUT_S then
		update_dirty = true
		return
	end
	update_in_flight_at = now

	sbar.exec(backend.fetch_state_cmd(), function(output)
		update_in_flight_at = 0

		-- Three sections, "---" separated: windows, workspace list, focused id.
		local workspace_icons = {}
		local seen = {}
		local workspaces = {}
		local focused = ""
		local section = 1

		for line in output:gmatch("[^\n]+") do
			if line == "---" then
				section = section + 1
			elseif section == 1 then
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
			elseif section == 2 then
				workspaces[#workspaces + 1] = line:gsub("%s+", "")
			else
				focused = line:gsub("%s+", "")
			end
		end

		-- A backend hiccup (window manager restarting, IPC not yet up) yields an
		-- empty list. Keep the current pills rather than blanking the bar; the
		-- next tick recovers.
		if #workspaces == 0 then
			if update_dirty then
				update_dirty = false
				update_all_spaces()
			end
			return
		end

		-- Reconcile the slot pool against the live workspace list. Reassigning a
		-- slot invalidates its cached state so the pill is rebuilt below.
		for i = 1, MAX_SLOTS do
			local ws = workspaces[i]
			if slot_ws[i] ~= ws then
				slot_ws[i] = ws
				slot_state[i] = nil
				if ws then
					slots[i]:set({ click_script = backend.click_cmd(ws) })
				else
					slots[i]:set({ drawing = false })
					slot_drawn[i] = false
				end
			end
		end

		local changed = {}
		for i = 1, MAX_SLOTS do
			local ws = slot_ws[i]
			if ws then
				local icons = workspace_icons[ws] or ""
				local selected = ws == focused
				local key = (selected and "1|" or "0|") .. icons
				if slot_state[i] ~= key then
					local was_drawn = slot_drawn[i] or false
					local now_drawn = selected or icons ~= ""
					slot_state[i] = key
					slot_drawn[i] = now_drawn
					changed[#changed + 1] = {
						slot = i,
						space = slots[i],
						icons = icons,
						selected = selected,
						label = backend.display_label(ws),
						drawing_flipped = was_drawn ~= now_drawn,
					}
				end
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
				local props = build_space_set(c.icons, c.selected, c.label)

				-- Remember the state colour separately from the colour actually
				-- shown: if the pointer is sitting on this pill while its state
				-- changes, it must land on the brightened variant, and
				-- mouse.exited must later restore the state colour, not the
				-- brightened one.
				local base = props.background.color
				slot_base_color[c.slot] = base
				local shown = slot_hovered[c.slot] and colors.brighten(base, colors.hover_amount) or base

				if c.drawing_flipped then
					props.background.color = shown
					c.space:set(props)
				else
					props.background = nil
					c.space:set(props)
					to_animate[#to_animate + 1] = { space = c.space, color = shown }
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
	end)
end

-- Create the pool up front, all hidden, so every slot is inside bracket.left
-- when items/init.lua builds it. Slots stay unnamed by workspace: the mapping
-- lives in slot_ws and is rewritten whenever the workspace set changes.
for i = 1, MAX_SLOTS do
	local space = sbar.add("item", "space.slot." .. i, {
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
			-- >= pill_height/2 so both the wide active pill and the square
			-- inactive one come out fully rounded.
			corner_radius = math.ceil(pill_height / 2),
			height = pill_height,
		},
		padding_left = 6,
		padding_right = 0,
		drawing = false,
	})

	-- Hover brightens the pill's current state colour. It can't use
	-- utils.hover_brighten, which assumes a fixed base: background.color here is
	-- state (accent when focused, bg2 otherwise) and is rewritten on every
	-- workspace switch, so hover has to read the live value out of
	-- slot_base_color rather than capturing one at setup.
	local index = i
	slot_base_color[i] = colors.bg2
	space:subscribe("mouse.entered", function()
		slot_hovered[index] = true
		space:set({
			background = { color = colors.brighten(slot_base_color[index], colors.hover_amount) },
		})
	end)
	space:subscribe({ "mouse.exited", "mouse.exited.global" }, function()
		slot_hovered[index] = false
		space:set({ background = { color = slot_base_color[index] } })
	end)

	slots[i] = space
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

-- routine fires every update_freq seconds — backstop against window manager
-- state changes (move-window, window close on inactive workspace, etc.) that
-- don't trigger one of the push events the backend lists.
local subscribed_events = { "routine" }
for _, ev in ipairs(backend.events) do
	subscribed_events[#subscribed_events + 1] = ev
end
-- Backends that push events via a helper process expose ensure_watcher() to
-- respawn it if it died (OmniWM rotates its IPC token on restart, which kills
-- the watcher). Piggy-backs on the routine tick, throttled — the check is a
-- process spawn, and the 5s routine is already the fallback if it has died.
local WATCH_CHECK_INTERVAL_S = 30
local last_watch_check = os.time()

observer:subscribe(subscribed_events, function(env)
	if backend.ensure_watcher then
		local now = os.time()
		if now - last_watch_check >= WATCH_CHECK_INTERVAL_S then
			last_watch_check = now
			backend.ensure_watcher()
		end
	end
	update_all_spaces()
end)

update_all_spaces()

return slots
