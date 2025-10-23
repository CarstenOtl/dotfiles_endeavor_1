-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd("hi Normal guibg=NONE")
    vim.cmd("hi NormalNC guibg=#000000")
    vim.cmd("hi SignColumn guibg=#000000")
    vim.cmd("hi VertSplit guibg=#000000")
  end,
})
