export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

bindkey -e

sh ~/.config/scripts/term-startup.sh

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/qdrtech/.zshrc'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias gitprune='sh ~/.config/scripts/git-prune.sh'
alias dle='sh ~/.config/scripts/docker-login-ecr.sh'
PS1='%n@%m %~$'

autoload -Uz compinit
compinit

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(starship init zsh)"

# bun completions
[ -s "/home/qdrtech/.bun/_bun" ] && source "/home/qdrtech/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export FZF_DEFAULT_COMMAND='fd'
export PATH=$PATH:$HOME/.config/scripts

export PATH="${PATH}:${HOME}/.local/bin/"

# Import colorscheme from 'wal'
(cat $HOME/.cache/wal/sequences)
