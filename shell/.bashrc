# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\u@\h \w\$ '

# Aliases
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

# Aliases for editing .files
alias eb='vim ~/.bashrc ; source ~/.bashrc'
alias sb="source ~/.bashrc"
alias ev="vim ~/.config/nvim/init.vim"
alias elc="vim ~/.alacritty.yml"

# xclip aliases
alias copy='xclip -selection clipboard -i'
alias paste='xclip -selection clipboard -o'

# Open a new terminal window
alias nw="alacritty &"

# Testing utility aliases
alias pyserve='python3 -m http.server 8002'

# ripgrep aliases
alias ff='rg -l' # Get all files that match the pattern in curdir
alias ffs='rg -lF' # Get all file that match that contain the given string

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

# TODO List
echo "TODO:"
lt () {
    echo "[ ] Finish AST parser section of Crafting Interpreters"
    echo "[ ] Merge work config file changes with local"
    echo "[ ] Configure the rest of arch"
    echo "    [ ] Go through the rest of the General Recommendations on Arch Wiki"
    echo "    [ ] Go through the configuration for Asus UX430 on Arch Wiki"
    echo "        [X] Install libinput for touchpad"
    echo "        [ ] Read documentation on how to use libinput with xorg"
    echo "        [ ] Install pulseaudio"
    echo "    [X] Install password manager (keepass or keepassxc?)"
    echo "    [X] Add SSH keys for github. Switch repos over to ssh"
    echo "[ ] Remove GNOME and have a more customized setup (eventually)"
    echo "    [ ] Look into the i3 window manager"
    echo "    [ ] Setup xinit"
}
lt

software=(
    git,
    firefox,
    neovim,
    xclip,
    alacritty,
    ripgrep,
    noto-fonts,
    htop,
    whois,
    tmux,
    keepassxc,
    open-ssh,
    keychain
)
