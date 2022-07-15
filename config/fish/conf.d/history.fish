shopt -s histappend
shopt -s checkwinsize

export HISTSIZE=20000
export HISTFILESIZE=20000
export PROMPT_COMMAND='history -a'
export HISTCONTROL=ignoreboth
