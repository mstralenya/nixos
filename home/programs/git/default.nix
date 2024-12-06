{user, ...}:
{
  programs = {
    git = {
      enable = true;
      userName = "Mikhail Stralenia";
      userEmail = "mstralenya@gmail.com";
      extraConfig = {
        url = {
          "git@github.com:" = {
            insteadOf = "gh:";
          };
          "https://github.com/" = {
            insteadOf = "github:";
          };
        };
      };
    };
  };
  services.git-sync = {
    enable = true;
    repositories = {
      doom-emacs = {
        uri = "https://github.com/doomemacs/doomemacs";
        path = "/home/${user}/.config/emacs";
      };
    };
  };
}
