{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      neomutt
    ];
  };
}
