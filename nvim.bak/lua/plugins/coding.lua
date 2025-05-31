return {
	-- Create annotations with one keybind, and jump your cursor in the inserted annotation
	{
		"danymat/neogen",
		keys = {
			{
				"<leader>cc",
				function()
					require("neogen").generate({})
				end,
				desc = "Neogen Comment",
			},
		},
		opts = { snippet_engine = "luasnip" },
	},

	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = true,
	},

	-- Refactoring tool
	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>r",
				function()
					require("refactoring").select_refactor()
				end,
				mode = "v",
				noremap = true,
				silent = true,
				expr = false,
			},
		},
		opts = {},
	},

	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen" },
		keys = { -- Example mapping to toggle outline
			{ "<leader>cs", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		config = function()
			require("outline").setup({
				outline_window = {
					position = "right",
				},
			})
		end,
	},

	{
		"nvim-cmp",
		dependencies = { "hrsh7th/cmp-emoji" },
		config = function()
			require("cmp").setup({
				enabled = function()
					-- disable completion in comments
					local context = require("cmp.config.context")
					-- keep command mode completion enabled when cursor is in a comment
					if vim.api.nvim_get_mode().mode == "c" then
						return true
					else
						return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
					end
				end,
			})
		end,
		opts = function(_, opts)
			table.insert(opts.sources, { name = "emoji" })
			table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
		end,
	},
}
