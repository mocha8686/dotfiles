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
zstyle :compinstall filename "$HOME/.zshrc"

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

# VCS Info
# setopt prompt_subst
# autoload -Uz vcs_info
# zstyle ':vcs_info:' enable git

# Environment variables
export EDITOR='nvim'
export LANG='en_US.UTF-8'
export PAGER='less'
export PS1='%f%K{1} %n@%M %F{1}%K{2}%f %~ %F{2}%K{3}%f %* %F{3}%k%f
%f%K{4} %# %F{4}%k%f '
export RPROMPT='%(?..%F{1}%k%f%K{1} %? %k)'
export GOPATH="$HOME/go"
path=("/usr/local/opt/gnu-tar/libexec/gnubin" "$HOME/.local/bin" "$HOME/.cargo/bin" "$GOPATH/bin" "$HOME/.local/share/nvim/mason/bin" "$HOME/.ghcup/bin" $path)

# Aliases
if command -v eza > /dev/null; then
	alias eza='eza --icons --git --group-directories-first'
	alias ls='eza'

	alias ll='eza -l --git-ignore'
	alias lt='ll -T'

	alias la='eza -la'
	alias lat='la -T'
else
	alias ll='ls -l'
	alias la='ll -a'
fi

alias mkdir='mkdir -pv'
function mkz() { mkdir -- "$1" && z "$1" }

function aw() { sleep ${1:-1} && hyprctl activewindow }

alias cx='chmod +x'
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -Iv'

alias nv='nvim'
alias nvup='nvim -c "PlugInstall | PlugClean"'

alias lg='lazygit'

alias ga='git add'
alias gaa='git add .'

alias gc='git commit'
alias gcm='git commit -m'
alias gac='gaa && gcm'
alias gcp='git commit --amend'
alias gcpm='git commit --amend -m'
alias gacpm='gaa && gcpm'
alias gcpn='git commit --amend --no-edit'
alias gacpn='gaa && gcpn'

alias gt='git stash'
alias gtp='git stash pop'

alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias gk='git checkout'
alias gl='git log --oneline --graph --decorate'
alias gw='git switch'

alias gp='git push'
alias gpu='git push -u origin'
alias gpl='git pull'
alias gf='git fetch'

alias nc='ncat'
alias ssh='TERM=xterm ssh'
alias ses='source ~/.session.sh'

function xsltopen() { xsltproc -o "$1".{html,xml} && open "$1".html }

alias get_idf='. $HOME/esp/esp-idf/export.sh'

eval "$(zoxide init zsh)"

if [[ -f ~/.os.sh ]] then
	source ~/.os.sh
fi

set -o allexport
source ~/.swww
set +o allexport

typeset -U path
export PATH

if [[ ! -z ${SESSION+x} ]] && [[ -f ~/.session.sh ]] then
	source ~/.session.sh
	unset SESSION
fi
