# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR="nvim"
export TERMINAL="alacritty"

# TODO: Look into bash history
# Bash history settings
shopt -s histappend
HISTSIZE=999999999
HISTFILESIZE=999999999
HISTCONTROL=ignoreboth

# Check and update window size, if necessary
shopt -s checkwinsize

# Colour prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]\$ '

# Add sass to PATH
export PATH="$HOME/repos/dart-sass:$PATH"

# Aliases
alias rm='rm --interactive=never'
alias cdh='cd ~'
alias d='cd ../'
alias dd='cd ../../'
alias ddd='cd ../../../'
alias ls='ls --color=auto'
alias la='ls --color=auto -al'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
if ! [ type nvim 2>/dev/null > /dev/null ]; then
    alias vim='nvim'
fi
alias v='vim'
alias sp='ps aux | rg -F'

# Aliases for editing .files
alias eb='vim ~/.bashrc ; source ~/.bashrc'
alias sb="source ~/.bashrc"
alias ev="vim ~/.config/nvim/init.vim"
alias elc="vim ~/.alacritty.yml"
alias et="vim ~/.tmux.conf"
alias etodo="vim ~/.todo; lt"

# xclip aliases
alias y='xclip -selection clipboard -i'
alias p='xclip -selection clipboard -o'

# Open a new terminal window
alias nw="alacritty &"

# Testing utility aliases
alias pyserve='python3 -m http.server 8002'

# ripgrep aliases
alias ff='rg -l' # Get all files that match the pattern in curdir
alias ffs='rg -lF' # Get all file that match that contain the given string
alias ffc='rg -F -C=5' # Search for string and show 5 lines above and below

alias startbl="sudo systemctl start bluetooth"
alias stopbl="sudo systemctl stop bluetooth"

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

alias shutdown="sudo shutdown -P 0"

# Show TODOs in the current directory
st() {
    rg -F TODO\($1\)
}

# List TODOs in the todo file
lt () {
    echo "TODO"
    if [ -f $HOME/.todo ]; then
        cat $HOME/.todo
    else
        touch $HOME/.todo
    fi
}
lt

# Journal for keeping notes
JOURNALDIR=$HOME/Documents
JOURNAL=$JOURNALDIR/journal
journal() {
    if [ ! -f $JOURNAL ]; then
        if [ ! -d $JOURNALDIR ]; then
            mkdir $JOURNALDIR
        fi
        touch $JOURNAL
    fi
    vim $JOURNAL
}
alias j="journal"

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

software=(
    alacritty,
    firefox,
    git,
    htop,
    keepassxc,
    keychain,
    neovim,
    nodejs
    noto-fonts,
    open-ssh,
    powertop,
    ripgrep,
    rsync,
    texlive-most,
    tlp,
    tmux,
    xclip,
    zathura,
)
