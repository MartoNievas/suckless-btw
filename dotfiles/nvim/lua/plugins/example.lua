return {
    -- Tema clásico
    { "ellisonleao/gruvbox.nvim" },
    {
        "LazyVim/LazyVim",
        opts = { colorscheme = "gruvbox" },
    },

    -- Buscar archivos
    { "nvim-telescope/telescope.nvim" },

    -- Syntax moderna (mínima)
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "c", "lua", "vim" } },
    },
}
