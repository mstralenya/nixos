{ pkgs, lib, config, ... }:
{
  boot = {
    bootspec.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
  environment.systemPackages = [ pkgs.sbctl ];
}
