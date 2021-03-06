# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="awesomepanda"
#
#ZSH_THEME="3den"
#ZSH_THEME="Soliah"
#ZSH_THEME="af-magic"
#ZSH_THEME="afowler"
#ZSH_THEME="alanpeabody"
#ZSH_THEME="bira"
#ZSH_THEME="blinks"
#ZSH_THEME="dogenpunk"
#ZSH_THEME="dpoggi"
#ZSH_THEME="fishy"
#ZSH_THEME="fletcherm"
#ZSH_THEME="gentoo"
#ZSH_THEME="kolo"
#ZSH_THEME="kphoen"
#ZSH_THEME="mikeh"
#ZSH_THEME="mortalscumbag"
#ZSH_THEME="muse"
ZSH_THEME="muse-mod"
#ZSH_THEME="pygmalion"
#ZSH_THEME="re5et"
#ZSH_THEME="rkj-repos"

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
#COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-extras github mvn mercurial cp rsync screen svn debian docker vagrant pip repo timewarrior zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose GIT_PS1_DESCRIBE_STYLE=branch GIT_PS1_SHOWCOLORHINTS=1
source $ZSH/plugins/gitfast/git-prompt.sh
#source $ZSH/plugins/git-prompt/git-prompt.plugin.zsh

if [ -f ~/.aliases ]; then
	    . ~/.aliases
    fi


# Customize to your needs...
HISTSIZE=500000
SAVEHIST=100000

#some environment variable
export PATH=$PATH:$HOME/bin/:$HOME/.local/bin

export EDITOR=vim

# rbenv
if [[ -d "$HOME/.rbenv/bin" ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# This loads projects' nvmrc, place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

PATH="/home/augustin/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/augustin/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/augustin/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/augustin/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/augustin/perl5"; export PERL_MM_OPT;

export USE_CCACHE=1

export PATH="$HOME/.cargo/bin:$PATH"
export ANSIBLE_NOCOWS=1

# added by travis gem
[ -f /home/augustin/.travis/travis.sh ] && source /home/augustin/.travis/travis.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# KDE dev
export PATH=~/kde/src/kdesrc-build:$PATH
