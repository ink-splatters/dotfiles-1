{ config, pkgs, ... }:

{
  imports = [
    ../git.nix
    ../htop.nix
    ../neovim.nix
    ../tmux.nix
    ../zsh.nix
    ../ssh.nix
    ../nix.nix
  ];
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    jq
  ];
}
