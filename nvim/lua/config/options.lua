-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "
vim.opt.guicursor = ""

vim.opt.number = true               -- Show line numbers.
vim.opt.colorcolumn = "100"         -- Show a vertical line at column 120.
vim.opt.title = true                -- Show the filename in the terminal title.
vim.opt.autoindent = true           -- Auto-indent new lines to match previous.
vim.opt.smartindent = true          -- Smarter auto-indenting for code blocks.
vim.opt.hlsearch = true             -- Highlight all matches of search pattern.
vim.opt.backup = false              -- Don’t create backup files.
vim.opt.showcmd = true              -- Show (part of) the last command in the bottom right.
vim.opt.cmdheight = 1               -- Height of the command line area.
vim.opt.laststatus = 3              -- Show a global statusline instead of one per window.
vim.opt.expandtab = true            -- Use spaces instead of tabs.
vim.opt.scrolloff = 10              -- Keep 10 lines above/below the cursor when scrolling.
vim.opt.shell = "fish"              -- Use Fish shell for commands.
vim.opt.inccommand = "split"        -- Show live preview of substitutions in a split.
vim.opt.ignorecase = true           -- Ignore case in search unless uppercase used.
vim.opt.smarttab = true             -- Use shiftwidth when pressing tab at line start.
vim.opt.breakindent = true          -- Preserve indent on wrapped lines.
vim.opt.shiftwidth = 4              -- Indent by 4 spaces when shifting.
vim.opt.tabstop = 4                 -- Display a tab as 4 spaces.
vim.opt.wrap = false                -- Don’t wrap long lines.
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })       -- Search subdirectories recursively with `:find`.
vim.opt.wildignore:append({ ... })  -- Ignore node_modules in file completion.
vim.opt.splitbelow = true           -- Open new horizontal splits below.
vim.opt.splitright = true           -- Open new vertical splits to the right.
vim.opt.splitkeep = "cursor"        -- Preserve cursor position when splitting.
vim.opt.cursorline = false           -- Don’t highlight the current line.
-- vim.opt.mouse = ""                  -- Disable mouse support.
-- vim.opt.cursorlineopt = "number"

vim.g.autoformat = true
vim.opt.list = false
-- vim.opt.fillchars = { eob = "~" }

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

-- Set file types for GLSL files
vim.filetype.add({
  extension = {
    frag = "glsl",
    vert = "glsl",
    comp = "glsl",
  },
})

vim.cmd([[set listchars=tab:\ \  list]])

-- LazyVim Disable Snacks animation globally
vim.g.snacks_animate = false
