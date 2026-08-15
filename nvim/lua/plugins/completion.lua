return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = { border = "rounded" },
        documentation = { window = { border = "rounded" } },
      },
    },
    init = function()
      -- Guard native snippet jumping against stale/leaked sessions.
      -- vim.snippet.active() only checks that a session object exists, not that
      -- its tabstop extmarks are still valid. After a snippet session leaks and
      -- the buffer is edited, the extmarks get invalidated and vim.snippet.jump
      -- crashes in snippet.lua:get_range ("attempt to index a nil value").
      -- Wrap the jump in pcall and stop the dead session on failure.
      local ok, cmp = pcall(require, "lazyvim.util.cmp")
      if ok then
        cmp.actions.snippet_forward = function()
          if vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              if not pcall(vim.snippet.jump, 1) then
                pcall(vim.snippet.stop)
              end
            end)
            return true
          end
        end
      end
    end,
  },
}
