function ColorMyPencils(color)
    -- require('rose-pine').setup({
    --     styles = {
    --         italic = false,
    --     }
    -- })

    -- require('gruvbox').setup({
    --     bold = false
    -- })

    color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
