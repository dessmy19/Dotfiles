return {
  { "akinsho/bufferline.nvim", enabled = false },
  { "nvim-lualine/lualine.nvim" },
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
