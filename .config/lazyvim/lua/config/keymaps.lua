local M = {}

local opts = { noremap = true }

-- custom maps
vim.keymap.set('i', 'umeter', 'µ', opts)
vim.keymap.set('i', ';;l', [[-------------------------------------------<CR><CR>]], opts)
vim.keymap.set('i', ';;d', [[============<C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>============<CR><CR>]], opts)

-- clear hls
vim.keymap.set('n', '<C-l>', ':nohl<CR><C-l>', opts)

-- show columns at 80 and 120
vim.keymap.set('n', '<leader>ro', [[:exe "set cc=" . (&cc == "" ? "80,120" : "")<CR>]], opts)
vim.keymap.set('n', '<leader>rl', [[:exe "set cuc! cul!"<CR>]], opts)
vim.keymap.set('n', '<leader>rr', [[:exe "set rnu! nu! list!"<CR>]], opts)

-- cursor remains in place after J
vim.keymap.set('n', 'J', [[mzJ`z]], opts)

-- paste over highlight, which deletes to void register
vim.keymap.set('x', '<leader>p', [["_dPa]], opts)

-- disable Q
vim.keymap.set('n', 'Q', '<nop>', opts)

-- quickfix navigation
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz', opts)
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz', opts)
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', opts)
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', opts)

return M
