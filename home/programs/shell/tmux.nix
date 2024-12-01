{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    prefix = "C-a";
    keyMode = "vi";

    extraConfig = ''
      # Enable extended keys for compatibility with alacritty/neovim
      set -s extended-keys always
      set -as terminal-features 'xterm*:extkeys'

      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g xterm-keys on
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      unbind t
      unbind C-t
      bind-key t new-window
      bind-key C-t new-window

      unbind w
      unbind C-w
      bind-key w kill-pane
      bind-key C-w kill-pane

      # yank from output
      bind-key Space copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Start windows and panes at 1, not 0
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # new panes inherit path
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # imported from here
      set -gq allow-passthrough on
      bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt

      bind-key -n C-Tab next-window
      bind-key -n C-S-Tab previous-window
      bind-key -n M-Tab new-window

      # change window names
      set -g window-status-format "#[fg=black,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#I #[fg=white,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#W #{b:pane_current_path} #[fg=brightblack,bg=black,nobold,noitalics,nounderscore]"
      set -g window-status-current-format "#[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#I #[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#W #{b:pane_current_path} #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
      #  make sure to update the window title every 5 seconds
      set -g status-interval 5

    '';

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      resurrect
      sensible
      cpu
      battery
      nord
      # catppuccin
    ];

  };
}

