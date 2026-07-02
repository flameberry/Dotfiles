return {
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      local palette = require("rose-pine.palette")
      -- Fall back gracefully for variants that don't define the custom base2.
      local float_bg = palette.base2 or palette.surface

      local colors = {
        bg = float_bg,
        bg_inactive = palette.surface,
        fg = palette.text,
        fg_inactive = palette.muted,
        modified = palette.gold,
        accent = palette.iris,
      }

      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 1, vertical = 1 },
        },
        hide = {
          -- "smart" hides only when the cursor/selection is actually under the
          -- label (top-right), not whenever it's on the same screen line — so
          -- the label stays visible with the cursor on the first line.
          cursorline = "smart",
          only_win = false,
        },
        render = function(props)
          local bufname = vim.api.nvim_buf_get_name(props.buf)
          local filename = vim.fn.fnamemodify(bufname, ":t")
          if filename == "" then
            filename = "[No Name]"
          end

          local modified = vim.bo[props.buf].modified
          local base_fg = props.focused and colors.fg or colors.fg_inactive
          local base_bg = props.focused and colors.bg or colors.bg_inactive

          -- Filetype icon via mini.icons
          local icon, icon_hl = require("mini.icons").get("file", filename)
          local icon_color = base_fg
          if props.focused then
            local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = icon_hl, link = false })
            if ok and hl.fg then
              icon_color = string.format("#%06x", hl.fg)
            end
          end

          -- Diagnostics
          local diagnostics = {}
          local signs = {
            [vim.diagnostic.severity.ERROR] = { icon = " ", color = palette.love },
            [vim.diagnostic.severity.WARN] = { icon = " ", color = palette.gold },
            [vim.diagnostic.severity.INFO] = { icon = " ", color = palette.foam },
            [vim.diagnostic.severity.HINT] = { icon = " ", color = palette.iris },
          }
          for severity, sign in pairs(signs) do
            local n = #vim.diagnostic.get(props.buf, { severity = severity })
            if n > 0 then
              table.insert(diagnostics, { sign.icon .. n .. " ", guifg = sign.color, guibg = base_bg })
            end
          end

          local res = {
            { "  ", guibg = base_bg },
            { icon .. " ", guifg = icon_color, guibg = base_bg },
            { filename, guifg = base_fg, guibg = base_bg, gui = props.focused and "bold" or "none" },
            modified and { "  ", guifg = colors.modified, guibg = base_bg } or "",
            { " ", guibg = base_bg },
          }

          if #diagnostics > 0 then
            table.insert(res, { " ", guibg = base_bg })
            for _, d in ipairs(diagnostics) do
              table.insert(res, d)
            end
          end

          return res
        end,
      })

      -- Keep incline below the treesitter-context lines.
      -- The context is a float anchored `relative = "win"` to its parent window
      -- (flagged via `w:treesitter_context`), sitting at the top. We offset
      -- incline's top margin by that block's height (context rows + separator).
      local function is_empty_border_piece(piece)
        if piece == nil or piece == "" then
          return true
        end
        if type(piece) == "table" then
          return piece[1] == nil or piece[1] == ""
        end
        return false
      end

      local function ts_context_offset(win)
        local max_h, has_sep = 0, false
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          local ok, cfg = pcall(vim.api.nvim_win_get_config, w)
          if ok and cfg.relative == "win" and cfg.win == win then
            local wv = vim.w[w]
            if wv and (wv.treesitter_context or wv.treesitter_context_line_number) then
              max_h = math.max(max_h, cfg.height or 0)
              -- A bottom border (indices 5-7) is the context separator line.
              if type(cfg.border) == "table" then
                if
                  not (
                    is_empty_border_piece(cfg.border[5])
                    and is_empty_border_piece(cfg.border[6])
                    and is_empty_border_piece(cfg.border[7])
                  )
                then
                  has_sep = true
                end
              end
            end
          end
        end
        if max_h == 0 then
          return 0
        end
        return max_h + (has_sep and 1 or 0)
      end

      local incline = require("incline")
      local manager = require("incline.manager")

      -- incline derives each window's top row from a single *global* margin, so
      -- it can't offset per-window. Instead we wrap the per-winline row function
      -- (which knows its own `target_win`) to push it below that window's own
      -- treesitter-context. The method table is shared by all winline instances
      -- via their metatable, so patching it once affects every window.
      local patched = false
      local function patch_winline()
        if patched then
          return true
        end
        local inst
        for _, w in ipairs(vim.api.nvim_list_wins()) do
          inst = manager.win_get_winline(w)
          if inst then
            break
          end
        end
        local mt = inst and getmetatable(inst)
        local Winline = mt and mt.__index
        if type(Winline) ~= "table" or type(Winline.get_win_geom_row) ~= "function" then
          return false
        end
        local orig = Winline.get_win_geom_row
        Winline.get_win_geom_row = function(self)
          local row = orig(self)
          local off = ts_context_offset(self.target_win)
          if off > 0 and vim.api.nvim_win_is_valid(self.target_win) then
            -- keep the label on-screen for very short windows
            off = math.min(off, math.max(0, vim.api.nvim_win_get_height(self.target_win) - 1))
            return row + off
          end
          return row
        end
        patched = true
        return true
      end

      local function refresh()
        patch_winline()
        pcall(incline.refresh)
      end

      -- Re-render incline the moment treesitter-context opens/closes its floats.
      -- Its updates are throttled (vim.schedule + 150ms timer), so listening to
      -- CursorMoved/WinScrolled ourselves would race and read stale float state
      -- (and leave incline stuck when the context disappears). Hooking the
      -- render functions themselves fires at exactly the right time, per window.
      local render = require("treesitter-context.render")
      for _, name in ipairs({ "open", "close", "close_contexts" }) do
        local orig = render[name]
        if type(orig) == "function" then
          render[name] = function(...)
            local ret = { orig(...) }
            vim.schedule(refresh)
            return unpack(ret)
          end
        end
      end

      vim.schedule(patch_winline)
    end,
  },
}
