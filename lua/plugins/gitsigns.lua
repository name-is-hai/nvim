return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {

      signs                   = {
        add          = { text = "▎", hl = "GitSignsAdd" },
        change       = { text = "▎", hl = "GitSignsChange" },
        delete       = { text = "", hl = "GitSignsDelete" },
        topdelete    = { text = "", hl = "GitSignsDelete" },
        changedelete = { text = "▎", hl = "GitSignsChange" },
        untracked    = { text = "▎", hl = "GitSignsUntracked" },
      },

      current_line_blame      = true,

      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' - right after the line, 'right_align' - far right
        delay = 500,           -- Shows up after half a second of resting your cursor
      },

      -- Set up keybindings that only load when you are in a Git repository
      on_attach               = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- 1. Navigation (Jump between changes)
        map("n", "]h", gs.next_hunk, "Next Git hunk")
        map("n", "[h", gs.prev_hunk, "Previous Git hunk")

        -- 2. Actions (Preview, Stage, and Revert)
        map("n", "<leader>hp", gs.preview_hunk, "Preview Git hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage Git hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset Git hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage entire file")
        map("n", "<leader>hR", gs.reset_buffer, "Reset entire file")

        -- 3. Detailed Blame
        map("n", "<leader>hb", function() gs.blame_line { full = true } end, "Full Blame popup")
      end,
    },
  }
}
