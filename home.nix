{ pkgs, ... }: {

  imports = [
    # Programs
    home/programs/nvim
    #home/programs/shell
    #home/programs/yazi

  ];

  home = {
    username = "admin";
    homeDirectory = "/home/admin";
  };

  programs.git = {
    enable = true;
    userName = "TKone7";
    userEmail = "tobias.koller@protonmail.com";
    signing.key = "C2DF82183835F07C397E5B54E14D3FA67208D7BD";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      core.editor = "nvim";
      commit.gpgsign = true;
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
