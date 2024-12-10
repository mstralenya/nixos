{ pkgs, config, ... }:
{
  home = {
    packages =
      (with pkgs; [
        tdesktop
        vesktop
        element-desktop
      ])
      ++ (with config.nur.repos; [
      ]);
  };
}
