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
}
