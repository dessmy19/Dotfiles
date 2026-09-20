return {
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local box = "#292e42"
      return {
        options = {
          theme = "tokyonight",
          globalstatus = true,
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { { "branch", color = { bg = box } }, { "diagnostics", color = { bg = box } } },
          lualine_c = { { "filename", color = { bg = box } } },
          lualine_x = { { "filetype", color = { bg = box } } },
          lualine_y = { { "progress", color = { bg = box } } },
          lualine_z = {
            { "location", color = { bg = box } },
            { function() return os.date("%H:%M") end, color = { bg = box } },
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
