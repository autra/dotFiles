# TODO list package dependencies
# git, vim, oh-my-zsh, spf13(?), 
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Add here all the files that needs to be symlinked into ~/.<dot-files>
DOT_FILES=vimrc gitconfig bashrc git_commit_msg.txt zshrc aliases
DOT_FILES_HOME=$(addprefix $(HOME)/.,$(DOT_FILES))

.PHONY: all dot-files install-vim install-neobundle

all: dot-files install-vim

dot-files: $(DOT_FILES_HOME)

$(DOT_FILES_HOME): $(HOME)/.%: $(ROOT_DIR)/%
	ln -s $(ROOT_DIR)/$* $(HOME)/.$*

install-vim: install-neobundle

install-neobundle: $(HOME)/.vim/bundle/neobundle.vim
	vim +NeoBundleInstall +qall

$(HOME)/.vim/bundle/neobundle.vim:
	mkdir -p ~/.vim/bundle
	git clone https://github.com/Shougo/neobundle.vim $(HOME)/.vim/bundle/neobundle.vim
