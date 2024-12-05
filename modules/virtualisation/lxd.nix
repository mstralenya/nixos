{ user, ... }:
{
  virtualisation.lxd.enable = false;
  users.users.${user} = {
    extraGroups = [ "lxd" ];
  };
}
