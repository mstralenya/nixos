{ pkgs, user, config, lib, ... }:
{
  programs.git.enable = true;

  services.resolved.enable = true;
  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall.allowedTCPPorts = [
      22 #sshd
      6600 #mpd
    ];
    hosts = {
      "185.199.109.133" = [ "raw.githubusercontent.com" ];
      "185.199.111.133" = [ "raw.githubusercontent.com" ];
      "185.199.110.133" = [ "raw.githubusercontent.com" ];
      "185.199.108.133" = [ "raw.githubusercontent.com" ];
    };
  };

  time.timeZone = "Europe/Warsaw";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ALL = "en_US.UTF-8";
      LANGUAGE = "en_US.UTF-8";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "C.UTF-8/UTF-8"
    ];
  };

  services = {
    openssh = {
      enable = true;
    };
    dbus.enable = true;
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    shells = with pkgs; [ fish ];
    systemPackages = with pkgs; [
      gcc
      clang
      gdb
      neovim
      wget
      neofetch
      eza
      p7zip
      atool
      unzip
      zip
      rar
      ffmpeg
      xdg-utils
      pciutils
      killall
      socat
      sops
      lsof
      rustscan
      onefetch
      jq
    ];
  };

  users.mutableUsers = false;
  users.users.root = {
    initialHashedPassword = "$6$lxmdznvXPgvRA.uq$R7Up1Eo1lrhaAbAGizrj/0dsbcU9DGKKVKLsA3bCrGYWkw/NkaQT.s41xTSqFkBZDXbucV00T2nN652D36AyG0";
  };
  programs.fish.enable = lib.mkIf (config.networking.hostName != "minimal") true;
  users.users.${user} = {
    initialHashedPassword = "$y$j9T$vS7YYYLF/Sv4xY429xmQn/$DCkBAo8.JwI4sFytsxW2jG1VVgGHSvIwn.F4W2I/el5";
    shell = lib.mkIf (config.networking.hostName != "minimal") pkgs.fish or pkgs.bash;
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" ];
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo = {
      enable = true;
      extraConfig = ''
        ${user} ALL=(ALL) NOPASSWD:ALL
      '';
    };
    doas = {
      enable = true;
      extraConfig = ''
        permit nopass :wheel
      '';
    };
  };

  system.stateVersion = "24.11";
}
