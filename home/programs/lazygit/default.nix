{
  programs.lazygit = {
    enable = true;
    settings = {
      os = {
        editPreset = "nvim-remote";
        editInTerminal = true;
      };
      customCommands = [
        {
          key = "G";
          context = "localBranches";
          command = "git reset --hard origin/{{.SelectedLocalBranch.Name}}";
          description = "Reset hard to origin";
          prompts = [
            {
              type = "confirm";
              title = "Reset to origin";
              body = "Are you sure you want to reset hard to origin/{{.SelectedLocalBranch.Name}}?";
            }
          ];
        }
        {
          key = "F";
          context = "remoteBranches";
          command = "git push -f origin HEAD:{{.SelectedRemoteBranch.Name}}";
          description = "Force push to remote origin branch";
          prompts = [
            {
              type = "confirm";
              title = "Force push";
              body = "Are you sure you want to force push {{.CheckedOutBranch.Name}} to origin HEAD:{{.SelectedRemoteBranch.Name}}?";
            }
          ];
        }
      ];
    };
  };
}

