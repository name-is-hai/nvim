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
            hidden = true,
            win = {
              list = {
                keys = {
                  ["A"] = "explorer_add_dotnet",
                },
              },
            },
            actions = {
              explorer_add_dotnet = function(picker)
                local dir = picker:dir()
                local easydotnet = require("easy-dotnet")

                easydotnet.create_new_item(dir, function(item_path)
                  local tree = require("snacks.explorer.tree")
                  local actions = require("snacks.explorer.actions")
                  tree:open(dir)
                  tree:refresh(dir)
                  actions.update(picker, { target = item_path })
                  picker:focus()
                end)
              end,
            },
          },
          files = {
            hidden = true,
          },
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
      -- Find & Explorer (<leader>f)
      { "<leader><space>", function() Snacks.picker.files() end,              desc = "Find Files" },
      { "<leader>fg",      function() Snacks.picker.grep() end,               desc = "Find Grep (Search Text)" },
      { "<leader>fe",      function() Snacks.explorer() end,                  desc = "File Explorer" },
      { "<leader>fb",      function() Snacks.picker.buffers() end,            desc = "Find Open Buffers" },

      -- Git & Terminal (<leader>g)
      { "<leader>gg",      function() Snacks.lazygit() end,                   desc = "Lazygit" },
      { "<c-/>",           function() Snacks.terminal() end,                  mode = { "n", "t" },                 desc = "Toggle Terminal" },

      -- LSP Navigation & Code (<leader>c)
      { "gd",              function() Snacks.picker.lsp_definitions() end,    desc = "Goto Definition" },
      { "gr",              function() Snacks.picker.lsp_references() end,     nowait = true,                       desc = "References" },
      { "<leader>cr",      function() Snacks.rename() end,                    desc = "Code Rename" },

      -- Diagnostics (<leader>x)
      { "<leader>xd",      function() Snacks.picker.diagnostics() end,        desc = "Search Diagnostics (Global)" },
      { "<leader>xD",      function() Snacks.picker.diagnostics_buffer() end, desc = "Search Diagnostics (Buffer)" },

      -- UI & Notifications (<leader>u)
      { "<leader>un",      function() Snacks.notifier.hide() end,             desc = "Dismiss All Notifications" },
      { "<leader>uh",      function() Snacks.notifier.show_history() end,     desc = "Notification History" },
    },
  },
}
