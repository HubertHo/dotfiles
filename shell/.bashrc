# Aliases
alias d='cd ../'
alias dd='cd ../../'
alias ddd='cd ../../../'
alias ls='ls --color=auto'
alias lsa='ls -al'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias v='nvim'

# Helpers for editing/automatically sourcing bashrc
alias editrc='vim ~/.bashrc ; source ~/.bashrc'
alias srcbash="source ~/.bashrc"

# Testing utility aliases
alias runtestserver='python3 -m http.server 8002'
alias runff2='cd /home/hho/ff2/ ; ./docker_wrap.py run dev --http_port 9000 --host_repo_path /home/hho/ff2'

# ripgrep aliases
alias ffreg='find . | rg'                  # Get all file paths that match pattern
alias ffsreg='rg -l'                       # Get all files that match the pattern in curdir
alias ffwebreg='find ~/ff/web | rg'        # Get all file paths from ff/web that match pattern
alias ffs='rg -lF'                         # Get all file that match that contain the given string
alias ffnotest='rg -F --iglob=\!*test*'    # Show lines that have matching string
alias ffsnotest='rg -Fl --iglob=\!*test*'  # Get all files but ignore the test files

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
    echo "[ ] Merge work bashrc with this version"
}
lt
