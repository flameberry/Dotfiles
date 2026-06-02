-- Rift backend for spaces.lua. Mirrors spaces_aerospace.lua's API so spaces.lua
-- can swap between window managers with one require line.
--
-- IDs are 0-based workspace indices as strings ("0", "1", ...) — rift's
-- `execute workspace switch` takes a numeric index, and the index is the only
-- field stable across renames.
--
-- fetch_state_cmd reshapes `rift-cli query workspaces` JSON into the same
-- two-section text format the aerospace backend produces, so the parser in
-- spaces.lua stays backend-agnostic.
--
-- The events below are sketchybar custom triggers — rift does not emit them on
-- its own. CLI subscriptions don't persist across rift restarts, so add to
-- ~/.config/rift/config.toml under [settings] to re-register on every start:
--
--   run_on_start = [
--     "rift-cli subscribe cli --event workspace_changed --command sketchybar --args --trigger --args rift_workspace_changed",
--     "rift-cli subscribe cli --event windows_changed  --command sketchybar --args --trigger --args rift_windows_changed",
--   ]
--
-- (rift appends the event JSON as a trailing arg; sketchybar's --trigger ignores
-- trailing args, so no shell wrapper is needed.)
-- Without these, the 5s routine in spaces.lua is the only update path.

local M = {}

M.events = { "rift_workspace_changed", "rift_windows_changed" }

function M.list_workspaces_cmd()
	return "rift-cli query workspaces | jq -r '.[].index'"
end

function M.fetch_state_cmd()
	return [[rift-cli query workspaces | jq -r '
		(.[] | select(.windows | length > 0) | .index as $i | .windows[] | "\($i)|\(.app_name)"),
		"---",
		(.[] | select(.is_active) | .index | tostring)
	']]
end

function M.click_cmd(workspace_id)
	return "rift-cli execute workspace switch " .. workspace_id
end

-- Pill label for the focused workspace. Rift's keybinds, `switch_to_workspace`
-- action, and CLI all use the 0-based `.index` directly — show it unchanged so
-- the bar matches what you'd type in `rift-cli execute workspace switch N`.
function M.display_label(workspace_id)
	return workspace_id
end

return M
