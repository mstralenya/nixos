{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/";
      clean-garbage = "nix-collect-garbage -d && sudo nixo-collect-garbage -d";
    };
    #histSize = 10000;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "thefuck"
      ];
      theme = "refined";
    };
  };
}
