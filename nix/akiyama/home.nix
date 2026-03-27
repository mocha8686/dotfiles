{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../home.nix
  ];

  home.file =
    let
      dotsym = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${path}";
    in
    {
      ".zprofile".source = dotsym "zsh/.zprofile";
    };

  home.homeDirectory = "/Users/mocha";
}
