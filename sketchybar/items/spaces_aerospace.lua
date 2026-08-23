-- Aerospace backend for spaces.lua. Paired with spaces_omniwm.lua — both expose
-- the same module surface so spaces.lua can swap between them with one line.
--
-- IDs are aerospace workspace names (e.g. "1", "2", "code").
-- fetch_state_cmd emits three sections separated by "---":
--   1. one "workspace_id|app_name" line per window
--   2. every workspace id, one per line, in display order
--   3. the focused workspace id on its own line
-- Section 2 is what lets spaces.lua reconcile workspaces appearing or
-- disappearing at runtime rather than only at config load.

local M = {}

M.events = { "aerospace_workspace_change", "front_app_switched" }

function M.fetch_state_cmd()
	return "aerospace list-windows --all --format '%{workspace}|%{app-name}'"
		.. " && echo '---' && aerospace list-workspaces --all"
		.. " && echo '---' && aerospace list-workspaces --focused"
end

function M.click_cmd(workspace_id)
	return 'aerospace workspace "' .. workspace_id .. '"'
end

-- Pill label for the focused workspace. Aerospace workspace IDs are already
-- the user-facing names ("1", "2", "code"), so show them as-is.
function M.display_label(workspace_id)
	return workspace_id
end

return M
