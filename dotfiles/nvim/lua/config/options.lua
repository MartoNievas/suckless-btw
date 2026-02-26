-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.lazyvim_check_order = false

vim.diagnostic.config({
    virtual_text = false, -- Esto quita el texto largo que ves a la derecha en tu imagen
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        wrap = true, -- <--- ESTO hará que el error tenga saltos de línea en el cuadro flotante
    },
})
