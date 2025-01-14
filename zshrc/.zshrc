export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/qdrtech/.zshrc'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='%n@%m %~$'

autoload -Uz compinit
compinit

eval "$(starship init zsh)"
