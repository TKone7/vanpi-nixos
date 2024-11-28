{ config, pkgs , ... }:
{

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # dirty hack because programs.fzf.colors do not reload when switching themes
    shellAliases = {
      st = "systemctl-tui";
      dt = "lazydocker";
      lg = "lazygit";
      mx = "tmuxinator";
      k = "k9s";
    };
  };
}

