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
      words = { enabled = false },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      lazygit = {
        configure = true,
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        globalstatus = true,
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          {
            function()
              --  
              return " " .. require("lualine.components.mode")():gsub("%s+", "")
            end,
            separator = { right = "" },
            right_padding = 2,
          },
        },
        lualine_c = { { "filename", path = 1 } },
        lualine_y = { "progress" },
        lualine_z = {
          { "location", separator = { left = "" }, left_padding = 2 },
        },
      },
    },
  },
}
