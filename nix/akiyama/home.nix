{
  config,
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
      "Library/Application Support/wallust".source = dotsym "wallust";
    };

  home.homeDirectory = "/Users/mocha";
}
