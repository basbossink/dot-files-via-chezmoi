set -U fish_greeting
set -U SXHKD_SHELL sh
set -gx SKIM_DEFAULT_COMMAND "fd --type f"
set -gx PATH $HOME/.cargo/bin $HOME/.local/bin $PATH

alias apt='doas /usr/bin/apt'
alias ll='exa --all --long --icons --classify --group-directories-first --sort name --time-style long-iso'
alias cm='chezmoi'
alias g='git'
alias vi='/home/bas/.local/bin/nvim.appimage'
alias vim='vi'
alias nvim='vi'
alias neovim='vi'
alias gvim='neovide'


zoxide init fish | source 
starship init fish | source 

if test -z (pgrep ssh-agent | string collect)
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end
