#
# ~/.bashrc
#

set -o vi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s histappend
shopt -s checkwinsize

export HISTSIZE=20000
export HISTFILESIZE=20000
export PROMPT_COMMAND='history -a'
export HISTCONTROL=ignoreboth

. /usr/share/bash-completion/bash_completion

# get current branch in git repo
function parse_git_branch() {
        BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\(.*\)/\1/'`
        if [ ! "${BRANCH}" == "" ]
        then
                STAT=`parse_git_dirty`
                echo "[${BRANCH}${STAT}]"
        else
                echo ""
        fi
}

# get current status of git repo
function parse_git_dirty {
        status=`git status 2>&1 | tee`
        dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
        untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
        ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
        newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
        renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
        deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
        bits=''
        if [ "${renamed}" == "0" ]; then
                bits=">${bits}"
        fi
        if [ "${ahead}" == "0" ]; then
                bits="*${bits}"
        fi
        if [ "${newfile}" == "0" ]; then
                bits="+${bits}"
        fi
        if [ "${untracked}" == "0" ]; then
                bits="?${bits}"
        fi
        if [ "${deleted}" == "0" ]; then
                bits="x${bits}"
        fi
        if [ "${dirty}" == "0" ]; then
                bits="!${bits}"
        fi
        if [ ! "${bits}" == "" ]; then
                echo " ${bits}"
        else
                echo ""
        fi
}

function ex() {
    if [ -f $1 ]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"  ;;
            *.tar.gz)   tar xzf "$1"  ;;
            *.bz2)      bunzip2 "$1"  ;;
            *.rar)      unrar x "$1"  ;;
            *.gz)       gunzip  "$1"  ;;
            *.tar)      tar xf  "$1"  ;;
            *.tbz2)     tar xjf "$1"  ;;
            *.tgz)      tar xzf "$1"  ;;
            *.zip)      unzip   "$1"  ;;
            *.xz)       unxz    "$1"  ;;
            *.zst)      zstd -d "$1"  ;;
            *.Z)        7z x    "$1"  ;;
            *)          echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

export PS1="\t: \[\e[32m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]: \[\e[31m\]\W\[\e[m\] \[\e[35m\]\`parse_git_branch\`\[\e[m\]\\$ \n"

# Util
alias ls='exa'
alias find='fd'
alias ll='ls -lah'
alias df='df -h'
alias pkDel='yay -Rs'
alias pkClean='yay -Scc'
alias pkUpdate='yay -Syu'
alias untar='tar -xzf'
alias htop="btop"
alias wetterHamburg="curl wttr.in/Hamburg"
alias batteryMode="sudo system76-power profile battery"

# Git
alias g="git"
alias gMail="gMailOtto"
alias gMailOtto='git config user.email "tom.dymel@otto.de"'
alias gMailWPS='git config user.email "tom.dymel@wps.de"'
alias gMailPrivate='git config user.email "tom@dymel.eu"'
alias gUncommit="git reset --soft HEAD~1"

# System Util
alias grubRedoConfig='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias mkinitRedo='sudo mkinitcpio -p linux'

eval "$(starship init bash)"

# EXPORTS
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$HOME/.config/bin
