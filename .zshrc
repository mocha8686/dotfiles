# The following lines were added by compinstall

zstyle ":completion:*" completer _ignored _approximate
zstyle ":completion:*" list-colors ""
zstyle ":completion:*" list-suffixes true
zstyle ":completion:*" matcher-list "m:{[:lower:]}={[:upper:]}" "r:|[._-]=* r:|=*"
zstyle ":completion:*" max-errors 3
zstyle ":completion:*" menu select=long
zstyle ":completion:*" preserve-prefix "//[^/]##/"
zstyle ":completion:*" select-prompt %SScrolling active: current selection at %p%s
zstyle ":completion:*" verbose true
zstyle :compinstall filename "/home/huece/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

# Environment variables
export RPROMPT="%(?..%?)"
export PS1="%F{1}┌─[%F{11}%n@%M%F{1}]──[%F{11}%~%F{1}]"$'\n'"└─[%F{11}%*%F{1}]─> %F{11}%#%F{white} "
export EDITOR="nvim"
export PAGER="less"
export LANG="en_US.UTF8"

# Aliases

# ls
alias ls="ls -h --color=auto"
alias ll="ls -l"
alias la="ll -a"

# Filesystem navigation
alias cl="cd -"
alias mkdir="mkdir -pv"
function mkcd()
{
	mkdir -- "$1" &&
	cd -- "$1"
}

# File manipulation
alias cx="chmod +x"
alias cp="cp -v"
alias mv="mv -v"
alias rm="rm -iv"

# grep
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# nvim
alias nv="nvim"
alias nvup="nvim +PlugInstall"
alias nvcl="nvim +PlugClean"
