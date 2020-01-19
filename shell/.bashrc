# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias vim='nvim'

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

# Unset the todo alias until we are certain that the .todo file exists
if [ alias edittodo 2>/dev/null >/dev/null ]; then
    unalias etodo
fi

# Only enable todo functionality if the file exists
TODOFILE="$HOME/.todo"
if [ -f "$TODOFILE" ]; then
    alias etodo='vim $TODOFILE'

    # Add a parser for the .todo file
    # while IFS= read -r line
    # do
    # done < "$TODOFILE"

    # Show list of tasks left to do
    echohigh() {
        echo -e "\033[1;31m$1"
    }

    echomed(){
        echo -e "\033[1;33m$1"
    }

    echolow(){
        echo -e "\033[1;32m$1"
    }

    todo() {
        printf "\n"
        # Urgent tasks that need to be done first
        echohigh "[MRG!1594]: Review request for assistant signup page changes (it's also a billion line change)"
        echohigh "[MRG!1635]: Get the implementation merge request merged"
        echohigh "[ISS#1071]: Branch from 694-implement... and add product metadata computation and endpoint"
        printf "\n"
        # Medium priority tasks, should be done but can wait on them
        echomed "[ISS#0694]: Add reads to (Interim)LocalizedProductProperty after writes have been merged."
        echomed "[MRG!1635]: Rename SupplyChainNetwork.get_supply_chain_lists_connecting_vendors because it isn't obvious what the"
        echomed "            arguments should be an in what order from the name"
        echomed "[MRG!1635]: Supply chain traversal and path computation needs some rethinking since the insertion function"
        echomed "            depends on the walker specifically walking in the upstream direction."
        echomed "                - This should wait until someone else has had a chance to look through these changes"
        printf "\n"
        # Low priority, will I even finish these?
        echolow "[TODO:---]: Clean up todos in code"
        echo -e "\033[0m"
        printf "\n"
    }

    todo
fi


notes() {
    echo "http://localhost/pro/signup/assistant/?vendors=2e77e13228f0488ca54a6991b1e84a6e,32f89a4465f2490ea8cadd91d42f4eba&locale=en-us&sponsor=UHJldmVyY28=&logo=L21lZGlhL3ZlbmRvcnMvcHJldmVyY28vaW1hZ2VzL2RlYWxlcl93aWRnZXRfbG9nby5wbmc="
}
