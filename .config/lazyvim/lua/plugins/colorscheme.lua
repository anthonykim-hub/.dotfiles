return {
  -- { 'projekt0n/github-nvim-theme' },
  -- { 'ellisonleao/gruvbox.nvim' },
  -- { 'rebelot/kanagawa.nvim' },
  -- { 'catppuccin/nvim', name = 'catppuccin' },
  -- { 'rose-pine/neovim', name = 'rose-pine' },
  -- { 'sainnhe/everforest' },
  -- { 'bluz71/vim-nightfly-colors' },
  -- { 'NLKNguyen/papercolor-theme' },
  -- { 'romainl/Apprentice' },
  -- { 'navarasu/onedark.nvim' },

  {
    'clearaspect/onehalf',
    lazy = false,
    priority = 1000,
  },

  -- Configure LazyVim to load colorscheme
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = 'onehalfdark',
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    },
  },
}
