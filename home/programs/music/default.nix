{ pkgs, inputs, ... }:

{
  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
  home = {
    packages = with pkgs; [
      #spotify
      playerctl
      pamixer
      (deadbeef-with-plugins.override {
        plugins = with deadbeefPlugins; [
          #lyricbar
          mpris2
        ];
      })
    ];
  };
}
