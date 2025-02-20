require("config.lazy")
require("config.lsp")
require("config.options")
require("config.keymap")
require("config.colors")

-- Setup plugins
require("nvim-treesitter.configs").setup({
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
})

require("neo-tree").setup({
  close_if_last_window = true,
  open_files_using_relative_paths = true,
  filesystem = {
    filtered_items = {
      visible = true,
      hide_gitignored = true,
      hide_hidden = false,
      hide_dotfiles = false,
    },
    follow_current_file = {
      enabled = true,
    },
    window = {
      mappings = {
        ["<leftrelease>"] = "open",
      },
    },
  },
})

require("lualine").setup({
  options = {
    section_separators = "",
    component_separators = "",
  },
  extensions = {
    "lazy",
    "mason",
    "neo-tree",
  },
})

require("gitsigns").setup()

-- File associations
vim.filetype.add({
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
  },
})

-- Autocommands
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {
    "*.lua",
    "*.nix",
  },
  command = "Neoformat",
})
