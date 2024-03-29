THEME_BG=light
# THEME_BG=dark
# Path to your oh-my-zsh configuration.
#zmodload zsh/zprof
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=~/dotFiles/zsh_custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="muse-mod"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(evalcache git gitfast git-extras mvn mercurial cp rsync screen svn debian docker vagrant pip repo timewarrior zsh-autosuggestions jq zsh-syntax-highlighting autojump)

source $ZSH/oh-my-zsh.sh
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1

if [ -f ~/.aliases ]; then
  . ~/.aliases
fi

# Customize to your needs...
HISTSIZE=500000
SAVEHIST=100000

#some environment variable
export PATH=$HOME/pgsql/bin:$PATH:$HOME/bin/:$HOME/.local/bin

export EDITOR=lvim

# rbenv
if [[ -d "$HOME/.rbenv/bin" ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  _evalcache rbenv init -
fi

export USE_CCACHE=1

# already in zprofile TODO version it
export PATH="$HOME/.cargo/bin:$PATH"
export ANSIBLE_NOCOWS=1

# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
  source /usr/share/doc/fzf/examples/completion.zsh
fi
# this, alongside .git in ~/.fdignore, allows fzf to show hidden files tracked by git.
# it also shows *all* hidden files, but well...
#
export FZF_DEFAULT_COMMAND="fd -H"
export FZF_CTRL_T_COMMAND="fd -H \$dir"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --theme=ansi {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# for telescope, workaround for it not showing .gitignore, .gitlab-ci.yml for instance
alias fd="fd -H"

export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# KDE dev
export PATH=~/kde/src/kdesrc-build:$PATH

function timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do time $shell -i -c exit; done
}
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# customize pager for glab
export GLAB_PAGER="less -FX"
export GLAMOUR_STYLE="light"
# doesn't work...
# autoload -U compinit
# compinit -i
# _evalcache glab completion -s zsh

if [ -e /home/augustin/.nix-profile/etc/profile.d/nix.sh ]; then . /home/augustin/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

eval "$(starship init zsh)"
