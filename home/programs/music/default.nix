{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      spotify
      playerctl
      spicetify-cli
      pamixer
      (deadbeef-with-plugins.override {
        plugins = with deadbeefPlugins; [
          lyricbar
          mpris2
        ];
      })
    ];
  };
}
