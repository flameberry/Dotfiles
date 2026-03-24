-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Move line up and down
local opts1 = { noremap = true, silent = true, nowait = true }
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts1)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts1)

vim.keymap.set("x", "<Leader>p", '"_dP')
vim.keymap.set("n", "x", '"_x')

-- Increment/decrement
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")

-- Resize window
vim.keymap.set("n", "<C-w><left>", "<C-w><")
vim.keymap.set("n", "<C-w><right>", "<C-w>>")
vim.keymap.set("n", "<C-w><up>", "<C-w>+")
vim.keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostics
local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-n>", function()
  vim.diagnostic.jump({ count = 1, float = false }) -- false, because of tiny-inline-diagnostic
end, opts)

vim.keymap.set("n", "<C-S-n>", function()
  vim.diagnostic.jump({ count = -1, float = false }) -- false, because of tiny-inline-diagnostic
end, opts)

-- CPP => Jump between source and header files
vim.keymap.set(
  "n",
  "<leader>ch",
  "<cmd>LspClangdSwitchSourceHeader<CR>",
  { desc = "Switch header/source", noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>k", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "Go to outer Treesitter context" })

vim.keymap.set("n", ":", ":", { noremap = true })
