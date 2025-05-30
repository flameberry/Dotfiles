local themes = {}

themes["rose-pine"] = {
	name = "rose-pine",
	theme = "rose-pine/neovim",
	config = {
		variant = "auto", -- auto, main, moon, or dawn
		dark_variant = "main", -- main, moon, or dawn
		dim_inactive_windows = false,
		extend_background_behind_borders = true,

		enable = {
			terminal = true,
			migrations = true, -- Handle deprecated options automatically
		},

		styles = {
			bold = true,
			italic = false,
			transparency = true,
		},

		groups = {
			border = "muted",
			link = "iris",
			panel = "surface",

			error = "love",
			hint = "iris",
			info = "foam",
			note = "pine",
			todo = "rose",
			warn = "gold",

			git_add = "foam",
			git_change = "rose",
			git_delete = "love",
			git_dirty = "rose",
			git_ignore = "muted",
			git_merge = "iris",
			git_rename = "pine",
			git_stage = "iris",
			git_text = "rose",
			git_untracked = "subtle",

			h1 = "iris",
			h2 = "foam",
			h3 = "rose",
			h4 = "gold",
			h5 = "pine",
			h6 = "foam",
		},

		palette = {
			-- Override the builtin palette per variant
			main = {
				-- base = "#000000",
				-- overlay = "#000000",
			},
		},

		-- NOTE: Highlight groups are extended (merged) by default. Disable this
		-- per group via `inherit = false`
		highlight_groups = {
			-- Normal = { bg = "#000000" },
			-- NormalNC = { bg = "#000000" },
			-- Comment = { fg = "foam" },
			-- StatusLine = { fg = "love", bg = "love", blend = 15 },
			-- VertSplit = { fg = "muted", bg = "muted" },
			-- Visual = { fg = "base", bg = "text", inherit = false },
		},

		before_highlight = function(group, highlight, palette)
			-- Disable all undercurls
			-- if highlight.undercurl then
			--     highlight.undercurl = false
			-- end
			--
			-- Change palette colour
			-- if highlight.fg == palette.pine then
			--     highlight.fg = palette.foam
			-- end
		end,
	},
}

themes["solarized-osaka"] = {
	theme = "craftzdog/solarized-osaka.nvim",
	config = {
		transparent = false,
	},
}

themes["nordic"] = {
	theme = "AlexvZyl/nordic.nvim",
	config = {},
}

themes["night-owl"] = {
	theme = "oxfist/night-owl.nvim",
	config = {},
}

themes["tokyonight"] = {
	theme = "folke/tokyonight.nvim",
	config = function()
		local bg = "#011628"
		local bg_dark = "#011423"
		local bg_highlight = "#143652"
		local bg_search = "#0A64AC"
		local bg_visual = "#275378"
		local fg = "#CBE0F0"
		local fg_dark = "#B4D0E9"
		local fg_gutter = "#627E97"
		local border = "#547998"

		require("tokyonight").setup({
			style = "night",
			transparent = true,
			on_colors = function(colors)
				colors.bg = bg
				colors.bg_dark = bg_dark
				colors.bg_float = bg_dark
				colors.bg_highlight = bg_highlight
				colors.bg_popup = bg_dark
				colors.bg_search = bg_search
				colors.bg_sidebar = bg_dark
				colors.bg_statusline = bg_dark
				colors.bg_visual = bg_visual
				colors.border = border
				colors.fg = fg
				colors.fg_dark = fg_dark
				colors.fg_float = fg
				colors.fg_gutter = fg_gutter
				colors.fg_sidebar = fg_dark
			end,
		})
		-- load the colorscheme here
		vim.cmd([[colorscheme tokyonight]])
	end,
}

themes["gruvbox-material"] = {
	theme = "sainnhe/gruvbox-material",
	config = {},
}

themes["gruvbox"] = {
	theme = "ellisonleao/gruvbox.nvim",
	config = {
		transparent_mode = true,
	},
}

themes["catppuccin-mocha"] = {
	name = "catppuccin",
	theme = "catppuccin/nvim",
	config = {
		flavour = "mocha",
		transparent_background = true,
		integrations = {
			aerial = true,
			alpha = true,
			cmp = true,
			dashboard = true,
			flash = true,
			gitsigns = true,
			headlines = true,
			illuminate = true,
			indent_blankline = { enabled = true },
			leap = true,
			lsp_trouble = true,
			mason = true,
			markdown = true,
			mini = true,
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			navic = { enabled = true, custom_bg = "lualine" },
			neotest = true,
			neotree = true,
			noice = true,
			semantic_tokens = true,
			telescope = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
		},
	},
}

-- THEME = "catppuccin-mocha"
THEME = "rose-pine"

return {
	{
		themes[THEME].theme,
		lazy = true,
		priority = 1000,
		opts = function()
			return themes[THEME].config
		end,
		config = function()
			require(themes[THEME].name).setup(themes[THEME].config)
			vim.cmd.colorscheme(themes[THEME].name)
		end,
	},
}
