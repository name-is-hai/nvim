return {
  "folke/trouble.nvim",
  event = "VeryLazy",
  cmd = "Trouble",
  opts = {
    -- The modern default settings are already incredibly clean
    modes = {
      diagnostics = {
        auto_close = false,  -- Keeps the panel open until you manually close it
        auto_preview = true, -- Shows you a peek of the code when you scroll through errors
      },
    },
  },
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics Panel (Project)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Diagnostics Panel (Buffer)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Document Symbols",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List",
    },
  },
}
