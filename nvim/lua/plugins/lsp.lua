return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      diagnostics = {
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        virtual_text = false,
      },
      servers = {
        jdtls = {
          settings = {
            java = {
              configuration = {
                runtimes = {},
              },
              format = {
                settings = {
                  ["org.eclipse.jdt.core.formatter.lineSplit"] = "120",
                },
              },
            },
          },
        },
      },
    },
  },
}
