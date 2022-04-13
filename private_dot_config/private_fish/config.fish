set -U fish_greeting
set -U SXHKD_SHELL sh
set -gx SKIM_DEFAULT_COMMAND "fd --type f"
set -gx PATH $HOME/.config/yarn/global/node_modules/.bin/ $HOME/.emacs.d/bin $HOME/.cargo/bin $HOME/.local/bin $PATH
set -gx EDITOR hx
set -gx VISUAL hx
set -gx GOPATH $HOME/proj/go
set -gx GOBIN $HOME/.local/bin
set -gx GO111MODULE "on"
set -gx TD_HOME $HOME/ds/code/td
set -gx PGHOST "/var/run/postgresql"

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
alias ledger='ledger -f $HOME/ds/.local/data/.timelog'

zoxide init fish | source 
starship init fish | source 

if test -z (pgrep ssh-agent | string collect)
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

function update-repo 
    pushd $argv[1]
    git fetch --prune --verbose
    popd
end

function update-repos
    ssh-add -l | rg -wq 'basbossink-ds'
    if test $status -ne 0 
        ssh-add $HOME/.ssh/id_basbossink-ds
    end
    pushd $TD_HOME
    for repo in (fd --max-depth 1 --type d);
        update-repo $repo
    end
    popd 
end

alias urs update-repos

function show-overtime
  ledger --daily reg | awk '{sum+=$5} END { \
  	overtime = sprintf("%d hours, %d minutes", int(sum-8*NR), int(((sum-8*NR)-int(sum-8*NR))*60)); \
    printf("\
Average number of hours worked per workday: = %g\n\
Number of days worked: = %d\n\
Overtime: = %s", sum/NR, NR, overtime) }' | column --table -s = 
end

alias over show-overtime

function skim_key_bindings

  # Store current token in $dir as root for the 'find' command
  function skim-file-widget -d "List files and folders"
    set -l commandline (__skim_parse_commandline)
    set -l dir $commandline[1]
    set -l skim_query $commandline[2]

    # "-path \$dir'*/\\.*'" matches hidden files/folders inside $dir but not
    # $dir itself, even if hidden.
    test -n "$SKIM_CTRL_T_COMMAND"; or set -l SKIM_CTRL_T_COMMAND "
    command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 's@^\./@@'"

    test -n "$SKIM_TMUX_HEIGHT"; or set SKIM_TMUX_HEIGHT 40%
    begin
      set -lx SKIM_DEFAULT_OPTIONS "--height $SKIM_TMUX_HEIGHT --reverse $SKIM_DEFAULT_OPTIONS $SKIM_CTRL_T_OPTS"
      eval "$SKIM_CTRL_T_COMMAND | "(__skimcmd)' -m --query "'$skim_query'"' | while read -l r; set result $result $r; end
    end
    if [ -z "$result" ]
      commandline -f repaint
      return
    else
      # Remove last token from commandline.
      commandline -t ""
    end
    for i in $result
      commandline -it -- (string escape $i)
      commandline -it -- ' '
    end
    commandline -f repaint
  end

  function skim-history-widget -d "Show command history"
    test -n "$SKIM_TMUX_HEIGHT"; or set SKIM_TMUX_HEIGHT 40%
    begin
      set -lx SKIM_DEFAULT_OPTIONS "--height $SKIM_TMUX_HEIGHT $SKIM_DEFAULT_OPTIONS --tiebreak=index --bind=ctrl-r:toggle-sort $SKIM_CTRL_R_OPTS --no-multi"

      set -l FISH_MAJOR (echo $version | cut -f1 -d.)
      set -l FISH_MINOR (echo $version | cut -f2 -d.)

      # history's -z flag is needed for multi-line support.
      # history's -z flag was added in fish 2.4.0, so don't use it for versions
      # before 2.4.0.
      if [ "$FISH_MAJOR" -gt 2 -o \( "$FISH_MAJOR" -eq 2 -a "$FISH_MINOR" -ge 4 \) ];
        history -z | eval (__skimcmd) --read0 --print0 -q '(commandline)' | read -lz result
        and commandline -- $result
      else
        history | eval (__skimcmd) -q '(commandline)' | read -l result
        and commandline -- $result
      end
    end
    commandline -f repaint
  end

  function skim-cd-widget -d "Change directory"
    set -l commandline (__skim_parse_commandline)
    set -l dir $commandline[1]
    set -l skim_query $commandline[2]

    test -n "$SKIM_ALT_C_COMMAND"; or set -l SKIM_ALT_C_COMMAND "
    command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
    -o -type d -print 2> /dev/null | sed 's@^\./@@'"
    test -n "$SKIM_TMUX_HEIGHT"; or set SKIM_TMUX_HEIGHT 40%
    begin
      set -lx SKIM_DEFAULT_OPTIONS "--height $SKIM_TMUX_HEIGHT --reverse $SKIM_DEFAULT_OPTIONS $SKIM_ALT_C_OPTS"
      eval "$SKIM_ALT_C_COMMAND | "(__skimcmd)' --no-multi --query "'$skim_query'"' | read -l result

      if [ -n "$result" ]
        cd $result

        # Remove last token from commandline.
        commandline -t ""
      end
    end

    commandline -f repaint
  end

  function __skimcmd
    test -n "$SKIM_TMUX"; or set SKIM_TMUX 0
    test -n "$SKIM_TMUX_HEIGHT"; or set SKIM_TMUX_HEIGHT 40%
    if [ -n "$SKIM_TMUX_OPTS" ]
      echo "sk-tmux $SKIM_TMUX_OPTS -- "
    else if [ $SKIM_TMUX -eq 1 ]
      echo "sk-tmux -d$SKIM_TMUX_HEIGHT -- "
    else
      echo "sk"
    end
  end

  bind \ct skim-file-widget
  bind \cr skim-history-widget
  bind \cs skim-cd-widget

  if bind -M insert > /dev/null 2>&1
    bind -M insert \ct skim-file-widget
    bind -M insert \cr skim-history-widget
    bind -M insert \cs skim-cd-widget
  end

  function __skim_parse_commandline -d 'Parse the current command line token and return split of existing filepath and rest of token'
    # eval is used to do shell expansion on paths
    set -l commandline (eval "printf '%s' "(commandline -t))

    if [ -z $commandline ]
      # Default to current directory with no --query
      set dir '.'
      set skim_query ''
    else
      set dir (__skim_get_dir $commandline)

      if [ "$dir" = "." -a (string sub -l 1 -- $commandline) != '.' ]
        # if $dir is "." but commandline is not a relative path, this means no file path found
        set skim_query $commandline
      else
        # Also remove trailing slash after dir, to "split" input properly
        set skim_query (string replace -r "^$dir/?" -- '' "$commandline")
      end
    end

    echo $dir
    echo $skim_query
  end

  function __skim_get_dir -d 'Find the longest existing filepath from input string'
    set dir $argv

    # Strip all trailing slashes. Ignore if $dir is root dir (/)
    if [ (string length -- $dir) -gt 1 ]
      set dir (string replace -r '/*$' -- '' $dir)
    end

    # Iteratively check if dir exists and strip tail end of path
    while [ ! -d "$dir" ]
      # If path is absolute, this can keep going until ends up at /
      # If path is relative, this can keep going until entire input is consumed, dirname returns "."
      set dir (dirname -- "$dir")
    end

    echo $dir
  end

end
skim_key_bindings
