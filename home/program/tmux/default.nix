{ pkgs }:

{
  enable = true;
  keyMode = "vi";
  historyLimit = 102400;
  terminal = "screen-256color";
  tmuxinator.enable = true;
  extraConfig = ''
    # Don't use a login shell
    set-option -g default-command $SHELL

    # Change bind key to ctrl-a
    unbind-key c-b
    set-option -g prefix c-a

    # Renumber windows when a window is closed
    set-option -g renumber-windows on

    # Repeat time limit (ms)
    set-option -g repeat-time 500

    # True color support
    set-option -ga terminal-overrides ",xterm-256color:Tc"

    # Key binding in the status line (bind-key :)
    set-option -g status-keys vi

    # Mouse
    set-option -g mouse on

    # -------------------------------------------------------------------
    # Window options
    # -------------------------------------------------------------------
    # Copy-mode
    set-window-option -g mode-keys vi

    # -------------------------------------------------------------------
    # Key bindings
    # -------------------------------------------------------------------
    # prefix c
    bind-key c new-window -c "#{pane_current_path}"

    # prefix ctrl-a
    bind-key c-a last-window

    # prefix a
    bind-key a send-prefix

    # prefix |
    bind-key | split-window -h -c "#{pane_current_path}"

    # prefix -
    bind-key - split-window -c "#{pane_current_path}"

    # Moving windows
    bind-key -r > swap-window -t :+
    bind-key -r < swap-window -t :-

    # Back and forth
    bind-key bspace previous-window
    bind-key space next-window
    bind-key / next-layout # Overridden

    # Pane-movement
    bind-key h select-pane -L
    bind-key l select-pane -R
    bind-key j select-pane -D
    bind-key k select-pane -U
    bind-key tab select-pane -t :.+
    bind-key btab select-pane -t :.-

    # Synchronize panes
    bind-key * set-window-option synchronize-pane

    # Reload ~/.tmux.conf
    bind-key R source-file ~/.config/tmux/tmux.conf \; display-message "Reloaded!"

    # Capture pane and open in Vim
    bind-key C-c run 'tmux capture-pane -S -102400 -p > /tmp/tmux-capture.txt'\;\
                 new-window "view /tmp/tmux-capture.txt"
    bind-key M-c run "screencapture -l$(osascript -e 'tell app \"iTerm\" to id of window 1') -x -o -P /tmp/$(date +%Y%m%d-%H%M%S).png"
  '';

  plugins = with pkgs.tmuxPlugins; [
    {
      plugin = catppuccin;
      extraConfig = ''
        # -------------------------------------------------------------------
        # Theme
        # -------------------------------------------------------------------
        set -g @catppuccin_window_left_separator ""
        set -g @catppuccin_window_right_separator " "
        set -g @catppuccin_window_middle_separator " █"
        set -g @catppuccin_window_number_position "right"

        set -g @catppuccin_window_default_fill "number"
        set -g @catppuccin_window_default_text "#W"
        set -g @catppuccin_window_current_fill "number"
        set -g @catppuccin_window_current_text "#W"

        set -g @catppuccin_status_modules_right "application session"
        set -g @catppuccin_status_left_separator  " "
        set -g @catppuccin_status_right_separator ""
        set -g @catppuccin_status_fill "icon"
        set -g @catppuccin_status_connect_separator "no"
      '';
    }
    sensible
    yank
    vim-tmux-navigator
  ];
}
