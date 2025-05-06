-- vim: tabstop=2 shiftwidth=2 expandtab

-- We almost always start by importing the wezterm module
local wezterm = require("wezterm")
-- Define a lua table to hold _our_ module's functions
local module = {}

-- Returns a bool based on whether the host operating system's
-- appearance is light or dark.
function module.is_dark()
	-- wezterm.gui is not always available, depending on what
	-- environment wezterm is operating in. Just return true
	-- if it's not defined.
	if wezterm.gui then
		-- Some systems report appearance like "Dark High Contrast"
		-- so let's just look for the string "Dark" and if we find
		-- it assume appearance is dark.
		return wezterm.gui.get_appearance():find("Dark")
	end
	return true
end

function module.coolnight(config)
	config.colors = {
		foreground = "#CBE0F0",
		-- background = "#011423",
		background = "#000000",
		cursor_bg = "#47FF9C",
		cursor_border = "#47FF9C",
		cursor_fg = "#011423",
		selection_bg = "#033259",
		selection_fg = "#CBE0F0",
		ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
		brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
	}
end

return module
