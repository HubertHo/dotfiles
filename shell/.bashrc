# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR="nvim"
export TERMINAL="alacritty"

# TODO(hubert): Look into bash history
# Bash history settings
shopt -s histappend
HISTSIZE=999999999
HISTFILESIZE=999999999
HISTCONTROL=ignoreboth

# Check and update window size, if necessary
shopt -s checkwinsize

# Colour prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\]\$ '

# List of software/packages installed
software=(
    alacritty
    discord
    dmenu
    firefox
    git
    htop
    i3lock
    i3status
    i3-wm
    keepassxc
    keychain
    neovim
    networkmanager
    nodejs
    noto-fonts
    open-ssh
    powertop
    python
    python-pip
    ripgrep
    rsync
    texlive-most
    tlp
    tmux
    xclip
    zathura
)

# Add directories to PATH
export PATH="$HOME/repos/dart-sass:$PATH"  # sass
export PATH="$HOME/.local/bin:$PATH"  # local scripts

# Path to todo file
export TODO=$HOME/.todo

# Aliases
alias rm='rm --interactive=never'
alias cdh='cd ~'
alias u='cd ../'
alias uu='cd ../../'
alias uuu='cd ../../../'
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
alias eb='vim ~/.bashrc ; source ~/.bashrc'
alias sb="source ~/.bashrc"
alias ev="vim ~/.config/nvim/init.vim"
alias elc="vim ~/.alacritty.yml"
alias et="vim ~/.tmux.conf"
alias etodo="vim $TODO; lt"

# Aliases for editing i3 config files
alias ei="vim ~/.config/i3/config"
alias eis="vim ~/.config/i3status/config"

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
alias ffs='rg -lF' # Get all file that match that contain the given string
alias ffc='rg -F -C=5' # Search for string and show 5 lines above and below

# tmux aliases
alias tk='tmux kill-server'
alias tsa='tmux attach-session -t'
alias tsk='tmux kill-session -t'
alias tsl='tmux list-session'
alias twk='tmux kill-window -t'
alias tcd='tmux detach-client'

# Open tmux just the way I like it
devmux() {
    SESSION="dev"
    tmux start-server
    tmux new-session -d -s $SESSION -n spotify
    tmux new-window -t $SESSION:1 -n code "nvim $TODO"
    tmux new-window -t $SESSION:2 -n terminal
    tmux select-window -t $SESSION:0
    tmux attach-session -t $SESSION
}

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

# Service aliases
alias spotify="spt"
alias startspotify="systemctl --user start spotifyd ; spt"
alias stopspotify="systemctl --user stop spotifyd; printf 'Spotifyd stopped\n'"

alias startbluetooth="sudo systemctl start bluetooth"
alias stopbluetooth="sudo systemctl stop bluetooth"

# Aliases for keepassxc, a password manager
export kpdb="$HOME/Documents/passdb.kdbx"
alias kpopen="keepassxc-cli open $kpdb"
alias kpshow="keepassxc-cli show -s $kpdb"
alias kpclip="keepassxc-cli clip $kpdb"

# Show available wifi networks (required network manager)
alias wifictl="nmcli device wifi"

# Make it easier to update packages
update-pkgbuild() {
    declare -a pkgs=(
        spotifyd
        spotify-tui
    )
    for pkg in "${pkgs[@]}"
    do
        cd $HOME/aurpkg/$pkg
        echo "Updating $pkg"
        git pull
        cd - > /dev/null
    done
}

update-system() {
    sudo pacman -Syu
    update-pkgbuild
}

# Show TODOs in the current directory
st() {
    rg -F TODO\($1\)
}

# List TODOs in the todo file
lt() {
    echo "TODO"
    if [ -f $TODO ]; then
        cat $TODO
    else
        touch $TODO
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

# Power management
suslock() {
    i3lock --color=1c1c1c --ignore-empty-password && systemctl suspend
}
