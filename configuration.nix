# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, configLib, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };

    services.xserver.videoDrivers = ["nvidia"];

    # Bootloader.
    boot.kernelParams = ["console=tty1"];
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking.hostName = "nixos"; # Define your hostname.

    # Enable networking
    networking.networkmanager.enable = true;

    #mount network drive
    fileSystems."/mnt/disk" = {
      device = "//192.168.8.1/disk";
      fsType = "cifs";
      options = let automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in ["${automount_opts},credentials=/etc/samba/smb-secrets,uid=1000,gid=100"];
    };

    # Set your time zone.
    time.timeZone = "Europe/Warsaw";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us,ru";
      variant = "";
      options = "grp:win_space_toggle";
    };

    # Enable CUPS to print documents.
    #services.printing.enable = true;

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };


    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.m = {
      isNormalUser = true;
      description = "Mikhail";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      packages = with pkgs; [
      ];
    };

    services.xserver.enable = true;
    services.greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    programs = {
      firefox.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      starship.enable = true;
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        # Certain features, including CLI integration and system authentication support,
        # require enabling PolKit integration on some desktop environments (e.g. Plasma).
        polkitPolicyOwners = [ "m" ];
      };
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #  wget
      #editors
      emacs
      neovim
      obsidian
      #terminal
      kitty
      yazi
      btop
      fastfetch
      zsh
      eza
      wget
      curl
      ripgrep
      gopass
      xarchiver
      unar
      unzip
      zip
      p7zip
      cifs-utils
      #messaging
      telegram-desktop
      discord
      #audio
      (deadbeef-with-plugins.override {
        plugins = with deadbeefPlugins; [
          lyricbar
          mpris2
        ];
      })
      spotify
      playerctl
      spicetify-cli
      pamixer
      tauon
      #video
      mpv
      kdenlive
      yt-dlp
      freetube
      #development
      git
      lazygit
      gcc
      clang
      zig
      gnumake
      python3
      devenv
      rustup
      #desktop
      hyprpaper
      hypridle
      hyprlock
      hyprpicker
      hyprshot
      pavucontrol
      rofi
      rofi-power-menu
      rofi-pulse-select
      waybar
      cava
      swayimg
      nyxt
      wl-clipboard
      cliphist
      grim
      grimblast
      slurp
      swappy
      qbittorrent
      zathura
      qutebrowser
      neomutt
      catgirl
      catppuccin-papirus-folders
      #games
      steam
      heroic
      pcsx2
      duckstation
      flycast
      ppsspp
      mangohud
      protonup-qt
    ];
    fonts = {
      packages = with pkgs; [
        noto-fonts unifont
        noto-fonts-emoji
        merriweather
        iosevka-comfy.comfy iosevka-comfy.comfy-duo
        (nerdfonts.override {fonts = [ "JetBrainsMono" ];})
      ];

      enableDefaultPackages = true;

      # this fixes emoji stuff
      fontconfig = {
        antialias = true;
        hinting.autohint = true;
        subpixel.rgba = "rgb";
        defaultFonts = {
          monospace = [
            "JetBrainsMono Nerd Font Mono"
            "Iosevka Comfy"
	          "Noto Color Emoji"
          ];
          sansSerif = [ "Iosevka Comfy Duo" "Noto Sans" ];
          serif = [ "Iosevka Comfy Motion Duo" "Noto Serif"];
          emoji = [ "Noto Color Emoji" "Noto Sans" ];
        };
      };
    };

    services.emacs = {
      enable = true;
      package = pkgs.emacs;
    };


    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
