#
# dotzsh : https://github.com/dotzsh/dotzsh
#
# Defines tmux aliases and provides for auto launching it at start-up.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   Colin Hebert <hebert.colin@gmail.com>
#

if (( ! $+commands[tmux] )); then
  return 2
fi

# Auto Start
if [[ -z "$TMUX" ]] && zstyle -t ':dotzsh:module:tmux' auto-start; then
  tmux_session='#DOTZSH'

  if ! tmux has-session -t "$tmux_session" 2> /dev/null; then
    # Disable the destruction of unattached sessions globally.
    tmux set-option -g destroy-unattached off &> /dev/null

    # Create a new session.
    tmux new-session -d -s "$tmux_session"

    # Disable the destruction of the new, unattached session.
    tmux set-option -t "$tmux_session" destroy-unattached off &> /dev/null

    # Enable the destruction of unattached sessions globally to prevent
    # an abundance of open, detached sessions.
    tmux set-option -g destroy-unattached on &> /dev/null
  fi

  exec tmux new-session -t "$tmux_session"
fi

# Aliases
alias ta="tmux attach-session"
alias tl="tmux list-sessions"

if (( $+commands[tmuxinator] )); then
  source ${0:h}/tmuxinator.zsh
fi

