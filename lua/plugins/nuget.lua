return {
  "d7omdev/nuget.nvim",
  cmd = { "NuGetInstall", "NuGetUpdate", "NuGetRemove" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvzone/volt",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("nuget").setup({
      key = {
        install = { "n", "<leader>pi" },
        remove = { "n", "<leader>pr" }
      }
    })
  end,
}
