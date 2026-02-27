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
    italic = true,
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
    Normal = { bg = "base" }, -- Transparent editor
    NormalFloat = { bg = "base2" },
    WinSeparator = { fg = "base" }, -- border contrast
    FloatBorder = { fg = "highlight_med", bg = "base2" }, -- Transparent border for most floats
    Pmenu = { bg = "base" }, -- Opaque completion menu
    PmenuSel = { bg = "overlay" }, -- Opaque selected item
    CmpItemMenu = { bg = "base" }, -- Opaque nvim-cmp menu
    CmpItemKind = { bg = "base" }, -- Opaque nvim-cmp kind icons
    CurSearch = { fg = "base", bg = "leaf", inherit = false },
    Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
    TreesitterContext = { bg = "surface" },
    TreesitterContextLineNumber = { bg = "surface", fg = "rose" },
    OutlineNormalBg = { bg = "base2" },
    -- StatusLine = { bg = "base" },
  },

  before_highlight = function(group, highlight, palette)
    -- Disable all undercurls
    -- if highlight.undercurl then
    --   highlight.undercurl = false
    -- end
    --
    -- Change palette colour
    -- if highlight.fg == palette.pine then
    --   highlight.fg = palette.foam
    -- end
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
