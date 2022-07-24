#-------------Source-----------------

# Cargo/Rust
source $HOME/.cargo/env

# Pure theme
fpath+=$HOME/.zsh/pure

#-------------Install znap------------
[[ -f ~/.zsh/zsh-snap/znap.zsh ]] ||
git clone --depth 1 -- \
https://github.com/marlonrichert/zsh-snap.git ~/.zsh/zsh-snap

source ~/.zsh/zsh-snap/znap.zsh  # Start Znap
znap prompt sindresorhus/pure

#-------------Plugins---------------

#znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting

#-------------------------------------

znap function _pyenv pyenvn 'eval "$( pyenv init - --no-rehash )"'
compctl -K    _pyenv pyenv

#-------------Init shell-------------

autoload -U promptinit; promptinit
prompt pure

# Auto start tmux
if [ "$TMUX" = "" ]; then tmux; fi

# Vim keybinds
bindkey -v

#-------------History-----------------

setopt histignorealldups sharehistory
HISTSIZE=3000
SAVEHIST=3000
HISTFILE=~/.zsh_history

#-------------Completion--------------

#autoload -Uz compinit
#compinit
#
#zstyle ':completion:*' auto-description 'specify: %d'
#zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' use-compctl false
#zstyle ':completion:*' verbose true
#
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#-------------Aliases-----------------

# Directories
alias config="cd ~/.config/dotfiles"

# Commands
alias ls="lsd"
alias ll="lsd -l"
alias la="lsd -la"

alias g="git"
alias gb="git checkout -b"
alias v="nvim"
alias e="emacs"

#-------------SSH agent---------------
[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)"
