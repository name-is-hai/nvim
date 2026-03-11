return {
  "nvim-neotest/neotest",
  -- Trigger loading when opening these file types OR pressing these keys
  ft = { "cs", "javascript", "typescript", "typescriptreact" },
  keys = {
    { "<leader>tr", function() require("neotest").run.run() end,                     desc = "Test: Run Nearest" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test: Debug Nearest" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Test: Run File" },
    { "<leader>ts", function() require("neotest").summary.toggle() end,              desc = "Test: Toggle Summary" },
    { "<leader>tw", function() require("neotest").watch.watch() end,                 desc = "Test: Watch" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Test: Show Output" },
    { "<leader>tA", function() require("neotest").run.run(vim.fn.getcwd()) end,      desc = "Test: Run All in Solution" },
  },
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Adapters
    "Issafalcon/neotest-dotnet",
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    { "stevanfreeborn/neotest-playwright", branch = "fork" },
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-jest"),
        require("neotest-vitest"),
        require("neotest-playwright").adapter({
          options = {
            preset = "headed",
            get_playwright_binary = function()
              return vim.loop.cwd() .. "/node_modules/.bin/playwright"
            end,
          },
        }),
        require("neotest-dotnet")({
          dap = { adapter_name = "coreclr" },
          -- Use "solution" to find tests based on .sln file
          discovery_root = "solution",
          dotnet_additional_args = { "--no-build" },
        }),
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        enabled = true,
        open = function()
          vim.cmd("copen")
        end,
      },
    })
  end,
}
