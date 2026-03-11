return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix", -- Keeps it as a compact vertical list on the right side
    delay = 300,
    icons = {
      mappings = true,
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add({
      -- Auto-groups based on your uploaded config files
      { "<leader>c", group = "Code (Actions & Format)", icon = " " }, -- conform.lua, lsp.lua
      { "<leader>d", group = "Debug / Diagnostics", icon = " " }, -- dap.lua, lsp.lua
      { "<leader>g", group = "Git", icon = " " }, -- snacks.lua
      { "<leader>h", group = "Git Hunks", icon = " " }, -- gitsigns.lua
      { "<leader>n", group = "Notifications", icon = " " }, -- snacks.lua
      { "<leader>p", group = "Packages (NuGet)", icon = " " }, -- nuget.lua
      { "<leader>r", group = "Refactor", icon = " " }, -- snacks.lua (rename)
      { "<leader>s", group = "Search", icon = " " }, -- snacks.lua
      { "<leader>t", group = "Test (Neotest)", icon = " " }, -- neotest.lua
      { "<leader>u", group = "UI / Utils", icon = "󰙵 " }, -- snacks.lua
      { "<leader>x", group = "Trouble (Problems Panel)", icon = " " }, -- trouble.lua
      { "<leader>b", group = "Buffers", icon = "󰓩 " },
    })
  end,
}
