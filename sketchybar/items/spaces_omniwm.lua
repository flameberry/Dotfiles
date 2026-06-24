-- OmniWM backend for spaces.lua. Mirrors spaces_aerospace.lua so spaces.lua can
-- swap window managers with one require line. Both the API and
-- the text format produced by fetch_state_cmd are identical across backends, so
-- the parser in spaces.lua stays backend-agnostic.
--
-- Talks to OmniWM over its IPC socket via the `omniwmctl` CLI. IPC must be
-- enabled (OmniWM status bar menu → Enable IPC; persisted as ipcEnabled in
-- omniwm/settings.toml) and `omniwmctl` must be on PATH (status bar menu →
-- Install CLI to PATH). Verified against OmniWM 0.5.0 / IPC protocol 5.
--
-- IDs are workspace *raw names* ("1".."9") — the stable rawName field.
-- These are what `workspace focus-name` accepts and what each window reports
-- under .workspace.rawName, so the same string keys windows, the focused marker,
-- and clicks. displayName is intentionally ignored: pills show the raw name.
--
-- omniwmctl query returns an IPCResponse envelope; the data lives under
-- .result.payload. fetch_state_cmd reshapes the windows + workspaces payloads
-- into the same two-section text format the aerospace backend emits:
--   1. one "rawName|appName" line per managed window
--   2. "---"
--   3. the focused workspace's rawName on its own line
-- .app.name matches aerospace's %{app-name}, so the shared app_icons lookup in
-- spaces.lua works unchanged.
--
-- Live updates: OmniWM does not fire sketchybar triggers on its own, so this
-- module starts a long-lived `omniwmctl watch` at load that fires the custom
-- trigger below on every active-workspace (workspace switch) and windows-changed
-- (window opened/closed/moved) event. The launch is idempotent — any prior
-- watcher is killed first — so reloading sketchybar (or swapping back to this
-- backend) never stacks watchers.
--
-- CPU NOTE: the `windows-changed` channel makes OmniWM do continuous
-- window-inventory refresh while subscribed — it was once measured adding a
-- sustained ~11–17% to OmniWM. Re-added by request; if OmniWM CPU climbs and
-- this watcher is the cause (rule out the Quake terminal first — see memory),
-- drop back to just `active-workspace`. `front_app_switched` is a built-in
-- sketchybar event covering app focus. Watcher dies when OmniWM restarts (IPC
-- token rotates); it respawns on the next sketchybar reload.

local M = {}

M.events = { "omniwm_workspace_changed", "front_app_switched" }

-- Start (or restart) the push-update watcher. `watch` runs the child once per
-- event and writes the event JSON to its stdin; `sketchybar --trigger` ignores
-- stdin, so no wrapper script is needed. Detached via a backgrounded subshell so
-- os.execute returns immediately.
os.execute(
	"pkill -f 'omniwmctl watch active-workspace' 2>/dev/null; "
		.. "(omniwmctl watch active-workspace,windows-changed "
		.. "--exec sketchybar --trigger omniwm_workspace_changed >/dev/null 2>&1 &)"
)

function M.list_workspaces_cmd()
	return [[omniwmctl query workspaces | jq -r '.result.payload.workspaces[].rawName']]
end

function M.fetch_state_cmd()
	-- Two queries joined the same way the aerospace backend joins its two
	-- commands. select(.workspace != null) drops scratchpad / unmanaged windows
	-- that have no home workspace. isFocused is true for exactly one workspace
	-- (the interaction monitor's active one), matching `aerospace list-workspaces
	-- --focused`.
	return [[omniwmctl query windows | jq -r '.result.payload.windows[] | select(.workspace != null) | "\(.workspace.rawName)|\(.app.name)"' && echo '---' && omniwmctl query workspaces | jq -r '.result.payload.workspaces[] | select(.isFocused) | .rawName']]
end

function M.click_cmd(workspace_id)
	-- focus-name takes the raw workspace ID and reaches workspaces on any
	-- monitor (switch-workspace is current-monitor only, so it can't reach the
	-- 7–9 workspaces pinned to the secondary display).
	return 'omniwmctl workspace focus-name "' .. workspace_id .. '"'
end

-- Pill label for a workspace. The raw name is already the user-facing id
-- ("1".."9", "A".."E"); displayName/emoji is ignored by design.
function M.display_label(workspace_id)
	return workspace_id
end

return M
