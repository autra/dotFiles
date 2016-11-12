# TODO list package dependencies
# git, vim, oh-my-zsh, spf13(?), 
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
# Customize this if you cloned zsh elsewhere
OH_MY_ZSH_DIR?=$(HOME)/.oh-my-zsh
CUSTOM_ZSH_THEME_DIR=$(OH_MY_ZSH_DIR)/custom/themes

# Add here all the files that needs to be symlinked into ~/.<dot-files>
DOT_FILES=vimrc gitconfig bashrc git_commit_msg.txt zshrc aliases
DOT_FILES_HOME=$(addprefix $(HOME)/.,$(DOT_FILES))

.PHONY: all dot-files install-vim install-neobundle

all: dot-files install-vim install-zsh

dot-files: $(DOT_FILES_HOME)

$(DOT_FILES_HOME): $(HOME)/.%: $(ROOT_DIR)/%
	ln -s $(ROOT_DIR)/$* $(HOME)/.$*

# Vim - instal
#install-vim: install-spf13

#install-neobundle: $(HOME)/.vim/bundle/neobundle.vim
	#vim +NeoBundleInstall +qall

#$(HOME)/.vim/bundle/neobundle.vim:
	#mkdir -p ~/.vim/bundle
	#git clone https://github.com/Shougo/neobundle.vim $(HOME)/.vim/bundle/neobundle.vim

# Zsh / Oh My Zsh!
.PHONY: install-zsh install-zsh-theme
install-zsh: install-zsh-theme

install-zsh-theme: $(CUSTOM_ZSH_THEME_DIR)
	ln -s $(ROOT_DIR)/muse-mod.zsh-theme $(HOME)/.oh-my-zsh/custom/themes/

$(CUSTOM_ZSH_THEME_DIR):
	mkdir -p $(CUSTOM_ZSH_THEME_DIR)
