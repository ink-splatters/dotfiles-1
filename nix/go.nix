{
  pkgs,
  nixpkgs,
  ...
}: {
  programs.go = {
    enable = true;
    goPath = "go";
  };
  programs.neovim = {
    extraConfig = ''
      let g:LanguageClient_serverCommands['go'] = ['gopls']
    '';
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [p.go]))
    ];
  };
  home.packages = with pkgs; [
    gotools
    gopls
    dep
    (
      if !stdenv.isDarwin
      then golangci-lint
      else nixpkgs.legacyPackages.aarch64-darwin.golangci-lint
    )
    clang # looks like gopls needs this
  ];
}
