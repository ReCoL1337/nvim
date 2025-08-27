return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "markdown", "markdown_inline", "zig", "htmldjango", "go", "python", "c", "lua", "vim", "vimdoc", "query", "heex", "javascript", "html" },
          sync_install = false,
          highlight = { enable = true , additional_vim_regex_highlighting = false },
        })
    end
}
