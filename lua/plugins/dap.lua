return {
  "mfussenegger/nvim-dap",
  ft = { "cs", "javascript", "typescript", "typescriptreact" },
  -- Keymaps
  keys = {
    { "<F5>",        function() require("dap").continue() end,          desc = "Debug: Start/Continue" },
    { "<S-F5>",      function() require("dap").terminate() end,         desc = "Debug: Stop/Terminate" },
    { "<C-S-F5>",    function() require("dap").restart() end,           desc = "Debug: Restart" },
    { "<F9>",        function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    { "<F10>",       function() require("dap").step_over() end,         desc = "Debug: Step Over" },
    { "<F11>",       function() require("dap").step_into() end,         desc = "Debug: Step Into" },
    { "<S-F11>",     function() require("dap").step_out() end,          desc = "Debug: Step Out" },

    -- Leader keys
    { "<leader>dbc", function() require("dap").clear_breakpoints() end, desc = "Clear all breakpoints" },
    { "<leader>dbl", function() require("dap").list_breakpoints() end,  desc = "List all breakpoints" },
    { "<leader>du",  function() require("dapui").toggle() end,          desc = "Toggle Debug UI Panels" },
  },
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    vim.env.DOTNET_ROLL_FORWARD = "Major"
    dap.defaults.fallback.exception_breakpoints = { "uncaught" }

    require("nvim-dap-virtual-text").setup({
      enabled = true,                     -- enable this plugin (default)
      enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, etc.
      highlight_changed_variables = true, -- highlight changed values with a different color
      highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables
      show_stop_reason = true,            -- show stop reason when stopped on a breakpoint
      commented = false,                  -- prefix virtual text with comment string
      only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
      all_references = false,             -- show virtual text on all references of the variable (not just definition)
      -- display_callback: how the virtual text is displayed
      display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == 'inline' then
          return ' = ' .. variable.value
        else
          return variable.name .. ' = ' .. variable.value
        end
      end,
      -- virt_text_pos: where the virtual text is displayed ('eol', 'overlay', 'inline')
      virt_text_pos = vim.fn.has('nvim-0.10') == 1 and 'inline' or 'eol',
    })
    -- UI Setup remains exactly as you had it
    dapui.setup({
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = "",
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = { border = "rounded", mappings = { close = { "q", "<Esc>" } } },
      force_buffers = true,
      icons = { collapsed = "", current_frame = "", expanded = "" },
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          position = "right",
          size = 50,
        },
        {
          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      render = { indent = 1, max_value_lines = 100 },
    })

    -- Node/Chrome/Edge Adapters remain the same
    for _, adapterType in ipairs({ "node", "chrome", "msedge" }) do
      local pwaType = "pwa-" .. adapterType
      dap.adapters[pwaType] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      dap.adapters[adapterType] = function(cb, config)
        local nativeAdapter = dap.adapters[pwaType]
        config.type = pwaType
        if type(nativeAdapter) == "function" then
          nativeAdapter(cb, config)
        else
          cb(nativeAdapter)
        end
      end
    end

    local enter_launch_url = function()
      local co = coroutine.running()
      return coroutine.create(function()
        vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:" }, function(url)
          if url == nil or url == "" then return else coroutine.resume(co, url) end
        end)
      end)
    end

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }) do
      dap.configurations[language] = {
        { type = "pwa-node",   request = "launch", name = "Launch file using Node.js (nvim-dap)",                       program = "${file}",                           cwd = "${workspaceFolder}" },
        { type = "pwa-node",   request = "attach", name = "Attach to process using Node.js (nvim-dap)",                 processId = require("dap.utils").pick_process, cwd = "${workspaceFolder}" },
        { type = "pwa-node",   request = "launch", name = "Launch file using Node.js with ts-node/register (nvim-dap)", program = "${file}",                           cwd = "${workspaceFolder}",     runtimeArgs = { "-r", "ts-node/register" } },
        { type = "pwa-chrome", request = "launch", name = "Launch Chrome (nvim-dap)",                                   url = enter_launch_url,                        webRoot = "${workspaceFolder}", sourceMaps = true },
        { type = "pwa-msedge", request = "launch", name = "Launch Edge (nvim-dap)",                                     url = enter_launch_url,                        webRoot = "${workspaceFolder}", sourceMaps = true },
      }
    end

    dap.defaults.fallback.exception_breakpoints = {}

    -- FIX 1: Dynamically grab the Arch Linux path to the Mason-installed netcoredbg
    dap.adapters.coreclr = {
      command = 'netcoredbg',
      type = "executable",
      args = { "--interpreter=vscode" },
    }

    -- The custom C# build and DLL path logic (This is awesome, keep this!)
    local dotnet_build_project = function()
      local default_path = vim.fn.getcwd() .. "/"
      if vim.g["dotnet_last_proj_path"] ~= nil then default_path = vim.g["dotnet_last_proj_path"] end
      local path = vim.fn.input("Path to your *proj file", default_path, "file")
      vim.g["dotnet_last_proj_path"] = path
      local cmd = "dotnet build -c Debug " .. path .. " > /dev/null"
      print("\nCmd to execute: " .. cmd)
      local f = os.execute(cmd)
      if f == 0 then print("\nBuild: ✔️ ") else print("\nBuild: ❌ (code: " .. f .. ")") end
    end

    local dotnet_get_dll_path = function()
      local request = function()
        return vim.fn.input("Path to dll to debug: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
      end
      if vim.g["dotnet_last_dll_path"] == nil then
        vim.g["dotnet_last_dll_path"] = request()
      else
        if vim.fn.confirm("Change the path to dll?\n" .. vim.g["dotnet_last_dll_path"], "&yes\n&no", 2) == 1 then
          vim.g["dotnet_last_dll_path"] = request()
        end
      end
      return vim.g["dotnet_last_dll_path"]
    end

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Launch - coreclr (nvim-dap)",
        request = "launch",
        program = function()
          if vim.fn.confirm("Rebuild first?", "&yes\n&no", 2) == 1 then
            dotnet_build_project()
          end
          return dotnet_get_dll_path()
        end,
      },
    }

    local convertArgStringToArray = function(config)
      local c = {}
      for k, v in pairs(vim.deepcopy(config)) do
        if k == "args" and type(v) == "string" then
          c[k] = require("dap.utils").splitstr(v)
        else
          c[k] = v
        end
      end
      return c
    end

    for key, _ in pairs(dap.configurations) do
      dap.listeners.on_config[key] = convertArgStringToArray
    end

    -- UI auto-open/close logic
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
  end,
}
