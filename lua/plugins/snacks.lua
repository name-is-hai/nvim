return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Performance
      bigfile = { enabled = true },
      quickfile = { enabled = true },

      -- UI & Visuals
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
      notifier = {
        enabled = true,
        timeout = 5000
      },
      image = { enabled = true },
      indent = {
        animate = {
          enabled = false,
        },
        indent = {
          enabled = true,
          char = "▏",
          hl = "LineNr",
          only_scope = false,
          only_current = true,
        },
        scope = {
          enabled = true,
          char = "▏",
          underline = false,
          hl = "Function",
        },
        chunk = {
          enabled = false,
        },
      },
      scope = { enabled = true, },
      explorer = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            hidden = true, },
          files = {
            hidden = true, },
        },
      },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = {
          open = false, git_hl = false,
        },
        git = {
          patterns = { "GitSign" },
        },
      },
    },
    keys = {
      -- File Searching & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end,              desc = "Smart Find Files" },
      { "<leader>sg",      function() Snacks.picker.grep() end,               desc = "Grep (Search Text)" },
      { "<leader>e",       function() Snacks.explorer() end,                  desc = "Toggle File Explorer" },

      -- Git & Terminal Workflows
      { "<leader>gg",      function() Snacks.lazygit() end,                   desc = "Lazygit" },
      { "<c-/>",           function() Snacks.terminal() end,                  mode = { "n", "t" },                 desc = "Toggle Terminal" },

      -- LSP Navigation (These will work once we set up your C#/TS servers)
      { "gd",              function() Snacks.picker.lsp_definitions() end,    desc = "Goto Definition" },
      { "gr",              function() Snacks.picker.lsp_references() end,     nowait = true,                       desc = "References" },
      { "<leader>rn",      function() Snacks.rename() end,                    desc = "Rename Symbol" },
      { "<leader>sd",      function() Snacks.picker.diagnostics() end,        desc = "Search Diagnostics (Global)" },
      { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end, desc = "Search Diagnostics (Buffer)" },

      -- Notification
      { "<leader>un",      function() Snacks.notifier.hide() end,             desc = "Dismiss All Notification" },
      { "<leader>nh",      function() Snacks.notifier.show_history() end,     desc = "Notification History" },
    },
  },
}
