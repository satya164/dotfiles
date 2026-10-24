return {
  { "drewtempelmeyer/palenight.vim" },
  { "github/copilot.vim" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  {
    "dense-analysis/ale",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "lua", "nix", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        callback = function(event)
          vim.b[event.buf].ale_disable_lsp = true
        end,
      })
    end,
  },
  { "sbdchd/neoformat" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "romgrk/barbar.nvim",
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
  { "lewis6991/gitsigns.nvim", lazy = true },
  { "f-person/git-blame.nvim", event = "VeryLazy" },
  { "sindrets/diffview.nvim", lazy = true },
  { "numToStr/Comment.nvim", lazy = true },
  { "windwp/nvim-ts-autotag", lazy = true },
  { "windwp/nvim-autopairs", lazy = true },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
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
