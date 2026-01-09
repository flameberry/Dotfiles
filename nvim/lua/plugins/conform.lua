return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "ruff_format" },
    },
    formatters = {
      ruff_format = {
        -- Extend the default arguments
        append_args = { "--line-length", "120" },
      },
    },
  },
}
