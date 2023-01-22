{
  config,
  pkgs,
  lib,
  ...
}: let
  vim-solarized8 = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "vim-solarized8";
    version = "2022-05-03";
    src = pkgs.fetchFromGitHub {
      owner = "lifepillar";
      repo = "vim-solarized8";
      rev = "9f9b7951975012ce51766356c7c28ba56294f9e8";
      sha256 = "1qg9n6c70jyyh38fjs41j9vcj54qmhkkyzna0la7bwsycqfxbs2x";
    };
  };
in {
  imports = [
    ./languageclient.nix
    ./vim-fugitive.nix
  ];
  options = {
    programs.neovim.treeSitterPlugins = lib.mkOption {
      type = lib.mkOptionType {
        name = "tree-sitter-plugins";
        description = "function suitable for nvim-treesitter.withPlugins";
        check = with lib.types; let
          grammars = pkgs.tree-sitter.builtGrammars // pkgs.vimPlugins.nvim-treesitter.builtGrammars;
        in (x:
          if builtins.isFunction x
          then builtins.isList (x grammars)
          else false);
        merge = loc: defs: p: lib.concatMap (f: f p) (lib.getValues defs);
      };
      default = _: [];
      defaultText = lib.literalExpression "(p: [ ])";
      example = lib.literalExpression "(p: with p; [ c java ])";
    };
  };
  config = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = builtins.readFile ./extraConfig.vim;
      plugins = with pkgs.vimPlugins; [
        vim-solarized8
        vim-nix
        vim-dispatch
        vim-obsession
        {
          plugin = nvim-treesitter.withPlugins config.programs.neovim.treeSitterPlugins;
          type = "lua";
          config = ''
            require'nvim-treesitter.configs'.setup {
              auto_install = false,
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              };
            }
          '';
        }
      ];
    };
    programs.git.ignores = [
      "Session.vim" # generated by vim-obsession
    ];
  };
}
