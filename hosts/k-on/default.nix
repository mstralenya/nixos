{
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "k-on";

  boot = {
    initrd.kernelModules = [ "nvidia" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    kernelParams = [
      "quiet"
      "splash"
      "nvidia-drm.modeset=1"
      "modprobe.blacklist=nouveau"
      "resume=/var/lib/swapfile"
      "console=tty1"
      "nvidia-drm.fbdev=1"
    ];
    supportedFilesystems = [ "ntfs" ];
  };
  # Bootloader.
  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    timeout = 12;
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = false;
      efiSupport = true;
      gfxmodeEfi = "1920x1080";
      fontSize = 18;
      font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFont-Regular.ttf";
      extraEntriesBeforeNixOS = true;
      default = 0;

      extraEntries = ''
        menuentry "Windows Boot Manager" {
          search --file --no-floppy --set=root /efi/Microsoft/Boot/bootmgfw.efi
          chainloader /efi/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
  };

  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 64 * 1024;
    }
  ];

  services = {
    auto-cpufreq.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
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
  environment = {
    systemPackages = (
      with pkgs;
      [
        libva
        libva-utils
        glxinfo
        egl-wayland
        (
          with dotnetCorePackages;
          combinePackages [
            dotnet_8.sdk
            dotnet_9.sdk
            dotnet_8.aspnetcore
            dotnet_9.aspnetcore
          ]
        )
      ]
    );
  };
  #mount network drive
  fileSystems."/mnt/disk" = {
    device = "//192.168.8.1/disk";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},uid=1000,gid=100" ];
  };
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:win_space_toggle";
  };
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "m";
    };
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
    };
  };

  environment.variables = {
    # WLR_RENDERER = "vulkan";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };
}
