set -U fish_greeting
set -U SXHKD_SHELL sh
set -gx SKIM_DEFAULT_COMMAND "fd --type f"
set -gx PATH ~/.emacs.d/bin $HOME/.cargo/bin $HOME/.local/bin $PATH
set -gx EDITOR hx
set -gx VISUAL hx

alias apt='doas /usr/bin/apt'
alias ll='exa --all --long --icons --classify --group-directories-first --sort name --time-style long-iso'
alias cm='chezmoi'
alias g='git'
alias vi='nvim'
alias vim='nvim'
alias edit='hx'
alias e='hx'
alias neovim='nvim'
alias gvim='neovide'

zoxide init fish | source 
starship init fish | source 

if test -z (pgrep ssh-agent | string collect)
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end
