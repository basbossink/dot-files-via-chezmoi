set -U fish_greeting
set -U SXHKD_SHELL sh
set -gx SKIM_DEFAULT_COMMAND "fd --type f"
set -gx PATH $HOME/.cargo/bin $HOME/.local/bin $PATH

alias apt='doas /usr/bin/apt'
alias ll='exa --all --long --icons --classify --group-directories-first --sort name --time-style long-iso'

zoxide init fish | source 
starship init fish | source 

