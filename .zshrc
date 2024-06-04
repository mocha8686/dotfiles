# The following lines were added by compinstall

zstyle ':completion:*' auto-description '[%d]'
zstyle ':completion:*' completer _expand _ignored _match _approximate _prefix
zstyle ':completion:*' completions 1
zstyle ':completion:*' condition 0
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format '[%d]'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%l'
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} r:|[._-]=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**' '+l:|=* r:|=*'
zstyle ':completion:*' match-original both
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=1
zstyle ':completion:*' old-list never
zstyle ':completion:*' original false
zstyle ':completion:*' prompt '[%e]'
zstyle ':completion:*' select-prompt '%p'
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/huece/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

# Startup commands
(cat ~/.cache/wal/sequences &)
source ~/.cache/wal/colors.sh
picom-trans -co 80

# Environment variables
export EDITOR="nvim"
export LANG="en_US.UTF8"
export PAGER="less"
export PS1="%F{1}┌─[%F{2}%n@%M%F{1}]──[%F{2}%~%F{1}]"$'\n'"└─[%F{2}%*%F{1}]─> %F{2}%#%F{white} "
#export PS1="%F{BG}┌─[%F{FG}%n@%M%F{BG}]──[%F{FG}%~%F{BG}]"$'\n'"└─[%F{FG}%*%F{BG}]─> %F{FG}%#%F{0} "
export RPROMPT="%(?..%?)"

# Aliases
alias x="exa --icons --git"
alias ls="x"
alias lt="ls -T"
alias ll="ls -l"
alias llt="x -lT"
alias la="ls -la"
alias lat="x -laT"

alias cl="cd -"
alias mkdir="mkdir -pv"
function mkcd() { mkdir -- "$1" && cd -- "$1" }

alias cx="chmod +x"
alias cp="cp -v"
alias mv="mv -v"
alias rm="rm -Iv"

alias nv="nvim"
alias nvup="nvim -c 'PlugInstall | PlugClean'"

alias ga="git add"
alias gaa="git add ."

alias gc="git commit"
alias gcm="git commit -m"
alias gac="gaa && gcm"
alias gcp="git commit --amend"
alias gcpm="git commit --amend -m"
alias gacpm="gaa && gcpm"
alias gcpn="git commit --amend --no-edit"
alias gacpn="gaa && gcpn"

alias gt="git stash"
alias gtp="git stash pop"

alias gs="git status"
alias gd="git diff"
alias gb="git branch"
alias gk="git checkout"
alias gl="git log --oneline --graph --decorate"
alias gw="git switch"

alias gp="git push"
alias gpu="git push -u origin"
alias gpl="git pull"
alias gf="git fetch"
