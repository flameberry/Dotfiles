return {
  "hedyhli/outline.nvim",
  config = function()
    require("outline").setup({
      outline_window = {
        winhl = "Normal:OutlineNormalBg,NormalNC:OutlineNormalBg",
      },
    })
    -- vim.api.nvim_set_hl(0, "OutlineNormalBg", { bg = "#1f1d2e" })
  end,
}
