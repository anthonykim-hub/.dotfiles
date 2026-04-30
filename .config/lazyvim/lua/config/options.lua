vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.python3_host_prog = '~/Projects/py3nvim/.venv/bin/python3'
vim.g.node_host_prog = '~/.local/bin/neovim-node-host'
vim.g.lazyvim_python_lsp = 'ty'
vim.g.lazyvim_python_ruff = 'ruff'
if vim.env.WSL_DISTRO_NAME then
  vim.g.clipboard = 'win32yank'
end
if vim.env.SSH_TTY and not vim.env.TMUX then
  vim.g.clipboard = 'osc52'
end
if vim.env.TMUX then
  vim.g.clipboard = 'tmux'
end
vim.opt.background = 'dark'
vim.opt.clipboard = 'unnamedplus,unnamed'
vim.opt.copyindent = true
vim.opt.cursorline = false
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = 'tab:»·,trail:·,nbsp:·'
vim.opt.mouse = ''
vim.opt.preserveindent = true
vim.opt.undofile = true
