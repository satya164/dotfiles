local wk = require("which-key")

wk.add {
  -- normal mode
  { "<leader>s", "<cmd>w<cr>", desc = "Save File", mode = "n" },
  { "<leader>q", "<cmd>q<cr>", desc = "Quit", mode = "n" },
  { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>b", "<cmd>Neotree toggle<cr>", desc = "Toggle File Tree", mode = "n" },
}
