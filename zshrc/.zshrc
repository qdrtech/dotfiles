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
alias ts='sh ~/.config/scripts/theme-switch.sh'

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
export FLYCTL_INSTALL="/home/qdrtech/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# Import colorscheme from 'wal', minus the background/highlight-background
# sequences (OSC 11/17/19/708). Those set an opaque background at runtime and
# override ghostty's background-opacity, killing terminal transparency.
if [[ -f $HOME/.cache/wal/sequences ]]; then
  sed -E 's/\x1b\](11|17|19|708);[^\x1b]*\x1b\\//g' "$HOME/.cache/wal/sequences"
fi

# pnpm
export PNPM_HOME="/home/qdrtech/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Aliases
alias ls="ls -G"
alias ll="ls -l"
alias la="ls -a"
alias l="ls -al"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias .........="cd ../../../../../../../.."


# opencode
export PATH=/home/qdrtech/.opencode/bin:$PATH
