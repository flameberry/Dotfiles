-- rose-pine ties italics to a broad set of groups. @variable alone matches
-- almost every identifier, so `styles.italic = true` italicizes whole files.
-- Strip italic from these high-frequency syntax groups in before_highlight,
-- leaving it only where it carries meaning: comments and markup emphasis
-- (@markup.italic, @text.emphasis, htmlItalic) keep their italics.
local no_italic = {
  ["Comment"] = true,
  ["@variable"] = true,
  ["@variable.parameter"] = true,
  ["@property"] = true,
}

local transparency = false

local config = {
  variant = "auto", -- auto, main, moon, or dawn
  dark_variant = "main", -- main, moon, or dawn

  dim_inactive_windows = false,
  extend_background_behind_borders = true,
  -- disable_background = true, -- Transparent background for editor
  -- disable_float_background = false, -- Non-transparent background for popups

  enable = {
    terminal = true,
    legacy_highlights = true,
    migrations = true, -- Handle deprecated options automatically
  },

  styles = {
    bold = true,
    italic = true, -- on globally; noisy groups are stripped in before_highlight
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
      base = "#0b0a10",
      -- base2 = "#141220",
      base2 = "#11101c",
      -- overlay = "#000000",
    },
  },

  highlight_groups = {
    Normal = { bg = transparency and "None" or "base" }, -- Transparent editor
    NormalFloat = { bg = transparency and "None" or "base2" },
    WinSeparator = { fg = "base" }, -- border contrast
    FloatBorder = { fg = "highlight_med", bg = transparency and "None" or "base2" }, -- Transparent border for most floats
    Pmenu = { bg = "base" }, -- Opaque completion menu
    PmenuSel = { bg = "overlay" }, -- Opaque selected item
    CmpItemMenu = { bg = "base" }, -- Opaque nvim-cmp menu
    CmpItemKind = { bg = "base" }, -- Opaque nvim-cmp kind icons
    CurSearch = { fg = "base", bg = "leaf", inherit = false },
    Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
    -- TreesitterContext = { bg = "surface" },
    TreesitterContextLineNumber = { bg = transparency and "None" or "base2", fg = "rose" },
    -- Separator is the context float's bottom border, so it follows FloatBorder
    -- (base2) unless set here. Pin the bg to base so it reads against the editor.
    TreesitterContextSeparator = { fg = "highlight_med", bg = "none" },
    OutlineNormalBg = { bg = transparency and "None" or "base2" },
    WinBar = { bg = "base2" }, -- dropbar.nvim renders into the winbar
    WinBarNC = { bg = "base2" },
    -- Bold plain variables (locals). Merges onto rose-pine's @variable so the
    -- fg (text) is kept; before_highlight still strips its italic.
    -- ["@lsp.type.variable"] = { fg = "text", bold = true },
  },

  before_highlight = function(group, highlight, palette)
    if no_italic[group] then
      highlight.italic = false
    end
  end,
}

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
    config = function()
      require("rose-pine").setup(config)
      vim.cmd.colorscheme("rose-pine")
      -- require("gruvbox-baby").colorscheme()
    end,
  },
}
