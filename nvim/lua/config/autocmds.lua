-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Override LazyVim's root detection behavior
-- Makes the current working directory the project root
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local cwd = vim.fn.getcwd() -- The directory passed to `nvim .`
    ---@diagnostic disable-next-line: duplicate-set-field
    require("lazyvim.util.root").get = function()
      return cwd
    end
  end,
})
