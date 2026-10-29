return {
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
