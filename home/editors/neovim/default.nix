{pkgs, ...}: {
  catppuccin.nvim.enable = true;

  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp-spell
      cmp-treesitter
      cmp-vsnip
      friendly-snippets
      gitsigns-nvim
      lightline-vim
      lspkind-nvim
      neogit
      null-ls-nvim
      nvim-autopairs
      nvim-cmp
      nvim-colorizer-lua
      nvim-lspconfig
      nvim-tree-lua
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      plenary-nvim
      rainbow-delimiters-nvim
      telescope-fzy-native-nvim
      telescope-nvim
      vim-floaterm
      vim-sneak
      vim-vsnip
      which-key-nvim
    ];

    extraPackages = with pkgs; [gcc ripgrep fd];
  };
}
