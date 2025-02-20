-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities =
  vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local wk = require("which-key")

    wk.add({
      {
        mode = "n",
        buffer = event.buf,
        { "K", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover" },
        { "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go to Definition" },
        { "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Go to Declaration" },
        { "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Go to Implementation" },
        { "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Go to Type Definition" },
        { "gr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Go to References" },
        { "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature Help" },
        { "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
        { "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", desc = "Format", mode = { "n", "x" } },
        { "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
      },
    })
  end,
})

require("mason").setup({})
require("mason-lspconfig").setup({
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({})
    end,
  },
})

---
-- Autocompletion config
---
local cmp = require("cmp")

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
  },
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ["<CR>"] = cmp.mapping.confirm({ select = false }),

    -- Ctrl+Space to trigger completion menu
    ["<C-Space>"] = cmp.mapping.complete(),

    -- Scroll up and down in the completion documentation
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})
