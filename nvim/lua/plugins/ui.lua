return {
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local c = {
        bg = "#1a1b26",
        blue = "#7aa2f7",
        cyan = "#7dcfff",
        green = "#9ece6a",
        magenta = "#bb9af7",
        red = "#f7768e",
        yellow = "#e0af68",
      }
      return {
        options = {
          theme = "tokyonight",
          globalstatus = true,
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_a = { { "mode", color = { bg = c.blue, fg = c.bg, gui = "bold" } } },
          lualine_b = { { "branch", color = { bg = c.magenta, fg = c.bg } } },
          lualine_c = { { "diagnostics" }, "filename" },
          lualine_x = { { "filetype", color = { bg = c.green, fg = c.bg } } },
          lualine_y = { { "progress", color = { bg = c.yellow, fg = c.bg } } },
          lualine_z = {
            { "location", color = { bg = c.cyan, fg = c.bg } },
            { function() return os.date("%H:%M") end, color = { bg = c.red, fg = c.bg } },
          },
        },
      }
    end,
  },
  {
    "folke/noice.nvim",
    opts = {
      views = {
        popup = { border = "single" },
        cmdline_popup = { border = { style = "single", padding = { 0, 1 } } },
        cmdline_input = { border = { style = "single", padding = { 0, 1 } } },
        confirm = { border = { style = "single", padding = { 0, 1 }, text = { top = " Confirm " } } },
      },
    },
  },
  { "folke/flash.nvim", enabled = false },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  {
    "snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      image = { enabled = false },
      lazygit = { enabled = false },
    },
  },
}
