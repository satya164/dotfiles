local wk = require("which-key")

wk.add({
  -- normal mode
  { "<leader>w", "<cmd>w<cr>", desc = "Write File", mode = "n" },
  { "<leader>q", "<cmd>q<cr>", desc = "Quit", mode = "n" },
  { "<leader>l", "<cmd>Lazy<cr>", desc = "Lazy", mode = "n" },

  { "<leader>f", group = "file" }, -- file group
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>fn", "<cmd>enew<cr>", desc = "New File", mode = "n" },
})
