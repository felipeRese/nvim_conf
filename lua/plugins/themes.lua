return {
  -- Kanagawa Theme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,  -- Loads early if needed
    config = function()
    end,
  },
  {
    "ishan9299/nvim-solarized-lua",
    lazy = false,
    priority = 1000,
    config = function()
    end,
  },

  -- Gruvbox Theme
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",  -- Options: "hard", "soft", or "medium"
      })
      -- Activate manually with: vim.cmd("colorscheme gruvbox")
    end,
  },

  -- OneDark Theme
  {
    "navarasu/onedark.nvim",
    lazy = false,
    config = function()
      require("onedark").setup({
        style = "dark"  -- Options include: "dark", "light", etc.
      })
      -- Activate using: vim.cmd("colorscheme onedark")
    end,
  },

  -- Nord Theme
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    config = function()
      -- Minimal configuration required.
      -- Activate with: vim.cmd("colorscheme nord")
    end,
  },

  -- Dracula Theme
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    config = function()
      -- Activate Dracula with:
      -- vim.cmd("colorscheme dracula")
    end,
  },

  -- Nightfox Theme
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    config = function()
      require("nightfox").setup({
        -- Customize Nightfox options if desired.
      })
      -- Activate using: vim.cmd("colorscheme nightfox")
    end,
  },

  -- Catppuccin Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",  -- Ensure proper resolution
    lazy = false,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",  -- Options: "latte", "frappe", "macchiato", "mocha"
      })
      vim.cmd("colorscheme catppuccin")
    end,
  },

  -- GitHub Theme (Default)
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    config = function()
      require("github-theme").setup({
        options = {
          transparent = false,
          -- Additional GitHub theme customization can be added here.
        },
      })
      -- Set the default theme to github_dark_high_contrast
    end,
  },

  -- Material Theme
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    config = function()
      vim.g.material_style = "darker"  -- Options: "ocean", "lighter", etc.
      -- Activate using: vim.cmd("colorscheme material")
    end,
  },

  -- Everforest Theme
  {
    "sainnhe/everforest",
    lazy = false,
    config = function()
      -- Activate with: vim.cmd("colorscheme everforest")
    end,
  },
}
