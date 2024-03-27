function ColoredCat(color)
	color = "colorscheme " and color or 'colorscheme catppuccin-mocha'
	vim.cmd(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColoredCat()
