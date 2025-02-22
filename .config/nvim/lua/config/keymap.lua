local wk = require("which-key")

wk.add({
  {
    mode = "n",
    { "<leader>w", "<cmd>w<cr>", desc = "Write File" },
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
    { "<leader>l", "<cmd>Lazy<cr>", desc = "Lazy" },

    { "<leader>f", group = "file" }, -- file group
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
    { "<leader>fn", "<cmd>enew<cr>", desc = "New File" },
  },
})
