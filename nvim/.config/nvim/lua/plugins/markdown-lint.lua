-- markdownlint reports plenty of useful things, but rendering them inline
-- (virtual text/underline/signs) clutters the markdown-preview rendering.
-- Keep the diagnostics fully queryable (<leader>sd / <leader>sD via fzf-lua,
-- or :Trouble diagnostics) by only turning off their inline display.
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(event)
    if event.data == "nvim-lint" then
      vim.diagnostic.config({
        virtual_text = false,
        underline = false,
        signs = false,
      }, require("lint").get_namespace("markdownlint-cli2"))
    end
  end,
})

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("~/.config/nvim/markdownlint.jsonc"), "-" },
        },
      },
    },
  },
}
