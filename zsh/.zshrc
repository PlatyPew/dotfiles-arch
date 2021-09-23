# Path to your oh-my-zsh installation.
export ZSH="/home/daryl/.oh-my-zsh"

ZSH_THEME="agnoster-dracula"

DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
    git
    zsh-syntax-highlighting
    colored-man-pages
    vi-mode
    web-search
    sudo
    extract
    # autojump
    # zsh-autosuggestions
)

## Autosuggestions config ##################################
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
############################################################

## Check if X11 is running #################################
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ]; then
    if [ "$XDG_VTNR" -eq 1 ]; then
        clear
        sleep 1.2
        # startx ~/.xinitrc_boot > /dev/null 2>&1
        nvidia-xrun > /dev/null 2>&1
        PS1="$USER@$(hostname)%% "
    fi
else
    source $ZSH/oh-my-zsh.sh
fi
############################################################

## Python ##################################################
ve() {
    if [[ -z ${VIRTUAL_ENV} ]]; then
        if [[ ! -d venv ]]; then
            virtualenv -p python3 venv
            source venv/bin/activate
        else
            source venv/bin/activate
        fi
        echo "python:  $(which python)"
        echo "python3: $(which python3)"
        echo "pip:     $(which pip)"
        echo "pip3:    $(which pip3)"
    else
        echo "You are already in a virtual environment"
        return 1
    fi
}

alias de='deactivate'
############################################################

## Misc Functions ##########################################
# Get Weather
weather() {
    sed '$ d' <(curl -s wttr.in/${1} | grep -v '@igor');
}

# Convert text to QR code
qrcode() {
    if [ -z ${1} ]; then
        echo "Usage: ${0} <string>"
        return 1
    else
        printf "${1}" | curl -s -F-=\<- qrenco.de
    fi
}

# Ulimate cheat sheet
howdafak() {
    if [[ -z ${1} || "${1}" == "-h" ]] then
        echo "Usage:    ${0} [-l] <topic> [query]"
        echo "Example:  ${0} c \"get string length\""
        echo "          ${0} python \"~file\" # Uses keyword \"file\""
        echo "          ${0} -l # Shows list of all topics"
        return 1
    elif [ ${1} = "-l" ]; then
        curl -s "https://cht.sh/:list" | grep -v '[/:]' | xargs -s 100 | tr " " "\t"
    else
        topic=${1}
        shift
        time curl -s "https://cht.sh/${topic}/${*}/i"
    fi
}

# Get rates of crypto currency
rate() {
    curl -s "https://sgd.rate.sx/${1}" | grep -v '@igor'
}

# Spawn IDE like environment using Neovim
ide() {
    if [[ -z $TMUX ]] then
        SESSION='dev'
        tmux -2 new-session -d -s $SESSION
        tmux send-keys "nvim ${1} '+call ToggleIDE()'" C-m
        tmux -2 attach-session -t $SESSION
    else
        nvim ${1} '+call ToggleIDE()'
    fi
}
############################################################

## FZF functions ###########################################
f() {
    MYPATH="$(pwd)"
    if [ ! -z $1 ]
    then
        MYPATH="${1}"
    fi

    rg ${MYPATH} --files --hidden --no-ignore-vcs 2> /dev/null | fzf -m --ansi --preview '[[ $(file --mime {}) =~ binary ]] && echo $(basename {}) is a binary file \($(file --mime-type {} | cut -d ":" -f 2 | cut -c 2-)\) || (bat --color=always --style=header,grid --line-range :200 {})'
}

ff() {
    MYPATH="$(pwd)"
    if [ ! -z $1 ]
    then
        MYPATH="${1}"
    fi

        FILE=$(rg ${MYPATH} --files --hidden --no-ignore-vcs -g '!.git/*' 2> /dev/null | fzf --ansi --preview '[[ $(file --mime {}) =~ binary ]] && echo $(basename {}) is a binary file \($(file --mime-type {} | cut -d ":" -f 2 | cut -c 2-)\) || (bat --color=always --style=header,grid --line-range :200 {})')

    if [ ! -z $FILE ]
    then
        nvim "${FILE}"
    fi
}

fd() {
    MYPATH="$(pwd)"
    if [ ! -z $1 ]
    then
        MYPATH="${1}"
    fi

    DIR="$(find ${MYPATH} -type d -name ".git" -prune -o -type d -print 2> /dev/null | fzf --ansi --preview 'exa -T --level 1 --color always {}')"

    if [ ! -z $DIR ]
    then
        cd "${DIR}"
    fi
}

ft(){
    if [ -z ${1} ]
    then
        echo "Usage: ${0} <search term>"
        return
    fi
    local match=$(
      rg --hidden --trim --vimgrep --color=never --line-number "$1" 2> /dev/null |
        fzf --no-multi --delimiter : \
            --preview "bat --color=always --line-range {2}: {1}"
      )
    local file=$(echo "$match" | cut -d':' -f1)
    if [[ -n $file ]]; then
        nvim $file +$(echo "$match" | cut -d':' -f2)
    fi
}

############################################################


### Vi-Mode ZSH #############################################
# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

# Beginning search with arrow keys
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Remove mode switching delay.
KEYTIMEOUT=5

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# Use beam shape cursor on startup.
echo -ne '\e[5 q'

# Use beam shape cursor for each new prompt.
_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)
############################################################

## Syntax highlighting configs ##############################
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[arg0]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[assign]='fg=192,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=4,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=220,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=220,bold'
############################################################

## Aliases #################################################
alias vi="nvim -O"
alias :q='exit'
alias cls='clear'
alias ls='exa --git --icons'
alias cat="bat --theme 'Monokai Extended'"
alias sonos="nohup swyh-rs 2>&1 > /dev/null & disown %$(jobs | grep swyh-rs | awk '{print $1}' | tr -d '[]')"
############################################################

export FZF_DEFAULT_COMMAND='rg $(pwd) --files --hidden --no-ignore-vcs -g "!.git/*" 2> /dev/null'
export PATH=$PATH:~/.local/bin
