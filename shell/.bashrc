# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR="nvim"
export TERMINAL="alacritty"

# Bash history settings
shopt -s histappend
HISTSIZE=999999999
HISTFILESIZE=999999999
HISTCONTROL=ignoreboth
export HISTFILE=$HOME/.bash_history

# Check and update window size, if necessary
shopt -s checkwinsize

# Show branch name in prompt if in git repository
prompt_branch(){
    branch_name=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
    # Strip brackets from branch name
    branch_name_length=${#branch_name}-2
    branch_name=${branch_name:1:$branch_name_length}
    if [ ${#branch_name} -eq 0 ]
    then
        echo ""
    elif [ ${#branch_name} -gt 25 ]
    then
        echo "(${branch_name:0:25}...)"
    else
        echo "($branch_name)"
    fi
}
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[\033[01;31m\]$(prompt_branch)\[\033[00m\] \$ '


# Add directories to PATH
export PATH="$HOME/repos/dart-sass:$PATH"  # sass
export PATH="$HOME/.local/bin:$PATH"  # local scripts

# Flutter development
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
export FLUTTER_SDK="/opt/flutter/bin/"

# Aliases
alias rm='rm --interactive=never'
alias cdh='cd $HOME'
alias u='cd ../'
alias uu='cd ../../'
alias uuu='cd ../../../'
alias uuuu='cd ../../../../'
alias uuuuu='cd ../../../../../'
alias ls='ls --color=auto'
alias la='ls --color=auto -al'
if ! [ type nvim 2>/dev/null > /dev/null ]; then
    alias vim='nvim'
fi
alias v='vim'
alias sp='ps aux | rg -F'
if ! [ type zathura 2>/dev/null > /dev/null ]; then
    alias z='zathura'
fi

# Aliases for editing dotfiles
alias eb='vim $HOME/.bashrc ; source $HOME/.bashrc'
alias sb="source $HOME/.bashrc"
alias ev="vim $HOME/.config/nvim/init.vim"
alias elc="vim $HOME/.alacritty.yml"
alias et="vim $HOME/.tmux.conf"

# Aliases for editing i3 config files
alias ei="vim $HOME/.config/i3/config"
alias eis="vim $HOME/.config/i3status/config"

# xclip aliases
alias y='xclip -selection clipboard -i'
alias p='xclip -selection clipboard -o'

# Clear the clipboard
alias clsc="echo '' | y"

# Open a new terminal window
alias nw="alacritty &"

# Testing utility aliases
alias pyserve='python3 -m http.server 8002'

# Setup black to use the custom config
alias black='black --config $HOME/.config/blackconf.toml'

# ripgrep aliases
alias ff='rg -l' # Get all files that match the pattern in curdir
alias ffs='rg -lF' # Get all files with name that matches given string
alias ffc='rg -F -C=5' # Search for files with matching string

# tmux aliases
alias t='tmux'
alias tk='tmux kill-server'
alias tsa='tmux attach-session -t'
alias tsk='tmux kill-session -t'
alias tsl='tmux list-session'
alias twk='tmux kill-window -t'
alias tcd='tmux detach-client'

# Git aliases
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gcl='git clone'
alias gcm='git commit -m'
alias gd='git diff'
alias gl='git log --pretty=oneline -n 20 --graph --abbrev-commit'
alias gm='git merge'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gt='git stash'
alias gtl='git stash list'
alias gtp='git stash push'
alias gto='git stash pop'
alias gts='git stash show -p'
alias gua='git pull && git submodule update --recursive --remote'

# Show TODOs in the current directory
st() {
    rg -F TODO\($1\)
}

# LaTeX
pdftex() {
    if ! [ type pdflatex 2>/dev/null > /dev/null ] && ! [ -z $1  ]; then
        if [ -d build ]; then
            rm -r build
        fi
        mkdir build;
        pdflatex -interaction=nonstopmode -output-directory=build $1;
    fi
}

# Power management
suslock() {
    i3lock --color=1c1c1c --ignore-empty-password && systemctl suspend
}
