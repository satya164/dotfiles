require("config.lazy")
require("config.lsp")
require("config.options")
require("config.keymap")
require("config.colors")

-- Setup plugins
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "markdown",
    "markdown_inline",
    "javascript",
    "typescript",
    "json",
    "yaml",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require('gitsigns').setup()

-- File associations
vim.filetype.add {
  filename = {
    Podfile = "ruby",
  },
  extension = {
    podspec = "ruby",
    mm = "objective-cpp",
    m = "objective-c",
    wgsl = "wgsl",
    eslintrc = "yaml",
    prettierrc = "yaml",
  }
}
