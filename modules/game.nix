{ pkgs, inputs, ... }:
{
  programs.anime-games-launcher.enable = true;
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  environment.systemPackages = [
    pkgs.protontricks
    pkgs.protonup-qt
  ];
}
