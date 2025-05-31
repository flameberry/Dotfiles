return {
  {
    "snacks.nvim",
    -- @class snacks.indent.Config
    -- @field enabled? boolean
    opts = {
      indent = {
        indent = {
          enabled = true,
          char = "¦", -- Dotted indent lines
        },
        animate = {
          enabled = false,
        },
        scope = {
          enabled = false, -- Disable scope highlighting
          char = "¦",
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },
}
