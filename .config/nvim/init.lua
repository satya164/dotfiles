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
    "bash",
    "query",
    "gitignore",
    "dockerfile",
    "markdown",
    "markdown_inline",
    "html",
    "css",
    "javascript",
    "typescript",
    "json",
    "yaml",
    "nix"
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = false,
    long_message_to_split = true,
    inc_rename = true,
    lsp_doc_border = true,
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

vim.g.barbar_auto_setup = false

require("barbar").setup({
  sidebar_filetypes = {
    ["neo-tree"] = true,
  },
})

require("lualine").setup({
  options = {
    section_separators = "",
    component_separators = "",
  },
  extensions = {
    "lazy",
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
