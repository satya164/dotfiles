return {
  { "drewtempelmeyer/palenight.vim" },
  { "github/copilot.vim" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/nvim-cmp" },
  { "dense-analysis/ale" },
  { "sbdchd/neoformat" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  { "nvim-tree/nvim-web-devicons" },
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
  { "lewis6991/gitsigns.nvim", lazy = true },
  { "sindrets/diffview.nvim", lazy = true },
  { "numToStr/Comment.nvim", lazy = true },
  { "windwp/nvim-ts-autotag", lazy = true },
  { "windwp/nvim-autopairs", lazy = true },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },
  { "nvim-lualine/lualine.nvim", dependencies = {
    "nvim-tree/nvim-web-devicons",
  } },
  {
    "folke/which-key.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
