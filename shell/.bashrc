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

source /usr/share/bash-completion/completions/git
source $HOME/.bash_aliases

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
