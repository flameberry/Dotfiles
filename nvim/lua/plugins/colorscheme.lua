local themes = {}

themes["rose-pine"] = {
    theme = "rose-pine/neovim",
    config = {
        styles = {
            bold = true,
            italic = true,
            transparency = true,
        },
    },
}

themes["solarized-osaka"] = {
    theme = "craftzdog/solarized-osaka.nvim",
    config = {
        transparent = false,
    },
}

themes["nordic"] = {
    theme = "AlexvZyl/nordic.nvim",
    config = {},
}

themes["night-owl"] = {
    theme = "oxfist/night-owl.nvim",
    config = {},
}

themes["tokyonight"] = {
    theme = "folke/tokyonight.nvim",
    config = function()
        local bg = "#011628"
        local bg_dark = "#011423"
        local bg_highlight = "#143652"
        local bg_search = "#0A64AC"
        local bg_visual = "#275378"
        local fg = "#CBE0F0"
        local fg_dark = "#B4D0E9"
        local fg_gutter = "#627E97"
        local border = "#547998"

        require("tokyonight").setup({
            style = "night",
            transparent = true,
            on_colors = function(colors)
                colors.bg = bg
                colors.bg_dark = bg_dark
                colors.bg_float = bg_dark
                colors.bg_highlight = bg_highlight
                colors.bg_popup = bg_dark
                colors.bg_search = bg_search
                colors.bg_sidebar = bg_dark
                colors.bg_statusline = bg_dark
                colors.bg_visual = bg_visual
                colors.border = border
                colors.fg = fg
                colors.fg_dark = fg_dark
                colors.fg_float = fg
                colors.fg_gutter = fg_gutter
                colors.fg_sidebar = fg_dark
            end,
        })
        -- load the colorscheme here
        vim.cmd([[colorscheme tokyonight]])
    end,
}

themes["gruvbox-material"] = {
    theme = "sainnhe/gruvbox-material",
    config = {},
}

themes["gruvbox"] = {
    theme = "ellisonleao/gruvbox.nvim",
    config = {
        transparent_mode = true,
    },
}

themes["catppuccin-mocha"] = {
    theme = "catppuccin/nvim",
    config = {
        flavour = "mocha",
        transparent_background = true,
        integrations = {
            aerial = true,
            alpha = true,
            cmp = true,
            dashboard = true,
            flash = true,
            gitsigns = true,
            headlines = true,
            illuminate = true,
            indent_blankline = { enabled = true },
            leap = true,
            lsp_trouble = true,
            mason = true,
            markdown = true,
            mini = true,
            native_lsp = {
                enabled = true,
                underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                },
            },
            navic = { enabled = true, custom_bg = "lualine" },
            neotest = true,
            neotree = true,
            noice = true,
            semantic_tokens = true,
            telescope = true,
            treesitter = true,
            treesitter_context = true,
            which_key = true,
        },
    },
}

THEME = "catppuccin-mocha"

return {
    {
        themes[THEME].theme,
        lazy = true,
        priority = 1000,
        opts = function()
            return themes[THEME].config
        end,
    },
}
