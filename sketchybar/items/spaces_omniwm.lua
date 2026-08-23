-- OmniWM backend for spaces.lua. Mirrors spaces_aerospace.lua so spaces.lua can
-- swap window managers with one require line. Both the API and the text format
-- produced by fetch_state_cmd are identical across backends, so the parser in
-- spaces.lua stays backend-agnostic.
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
-- into the three-section text format shared with the aerospace backend:
--   1. one "rawName|appName" line per managed window
--   2. "---"
--   3. every workspace's rawName, one per line, in display order
--   4. "---"
--   5. the focused workspace's rawName on its own line
-- Section 3 is what lets spaces.lua notice workspaces being added or removed at
-- runtime instead of only at config load. .app.name matches aerospace's
-- %{app-name}, so the shared app_icons lookup in spaces.lua works unchanged.
--
-- CPU NOTE: the `windows-changed` channel makes OmniWM do continuous
-- window-inventory refresh while subscribed — it was once measured adding a
-- sustained ~11–17% to OmniWM. Re-added by request; if OmniWM CPU climbs and
-- this watcher is the cause (rule out the Quake terminal first — see memory),
-- drop back to just `active-workspace`. `front_app_switched` is a built-in
-- sketchybar event covering app focus.

local M = {}

M.events = { "omniwm_workspace_changed", "front_app_switched" }

-- ── Push-update watcher ───────────────────────────────────────────────────
-- OmniWM does not fire sketchybar triggers on its own, so a long-lived
-- `omniwmctl watch` translates its events into one. `watch` runs the child once
-- per event and writes the event JSON to its stdin; `sketchybar --trigger`
-- ignores stdin, so no wrapper script is needed. Detached via a backgrounded
-- subshell so os.execute returns immediately.
--
-- The watcher dies whenever OmniWM restarts (the IPC token rotates). It used to
-- stay dead until the next sketchybar reload, silently downgrading the bar to
-- the 5s `routine` poll with no indication. It is now supervised: the PID is
-- recorded at launch and M.ensure_watcher() respawns it if that process is gone.
local PIDFILE = "/tmp/sketchybar_omniwm_watch.pid"

local WATCH_CMD = "omniwmctl watch active-workspace,windows-changed "
	.. "--exec sketchybar --trigger omniwm_workspace_changed"

local LAUNCH = "(" .. WATCH_CMD .. " >/dev/null 2>&1 & echo $! > " .. PIDFILE .. ")"

-- Clear watchers left behind by an older config revision that predates the
-- pidfile. The `[ ]` in the pattern is deliberate: pkill -f matches against full
-- command lines, and without it this pattern would match the very shell running
-- the pkill, killing it before the launch below could run. Kept in its own
-- os.execute for the same reason — so LAUNCH's text is not in that shell's argv.
os.execute("pkill -f 'omniwmctl[ ]watch' 2>/dev/null")
os.execute(LAUNCH)

-- Cheap liveness probe, called on a timer from spaces.lua. Matching on the
-- recorded PID rather than pgrep -f avoids both the self-match problem above and
-- false positives from the short-lived `omniwmctl query` calls that fetch_state
-- spawns; the command check guards against PID reuse. Fully async.
function M.ensure_watcher()
	sbar.exec(
		'ps -p "$(cat ' .. PIDFILE .. ' 2>/dev/null)" -o command= 2>/dev/null '
			.. "| grep -q omniwmctl || "
			.. LAUNCH
	)
end

function M.fetch_state_cmd()
	-- select(.workspace != null) drops scratchpad / unmanaged windows that have
	-- no home workspace. isFocused is true for exactly one workspace (the
	-- interaction monitor's active one), matching `aerospace list-workspaces
	-- --focused`. The workspace list and the focused marker come out of a single
	-- query — binding the payload to $w emits both sections without paying for a
	-- second omniwmctl round trip.
	return [[omniwmctl query windows | jq -r '.result.payload.windows[] | select(.workspace != null) | "\(.workspace.rawName)|\(.app.name)"' && echo '---' && omniwmctl query workspaces | jq -r '.result.payload.workspaces as $w | ($w[].rawName), "---", ($w[] | select(.isFocused) | .rawName)']]
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
