ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DOT_FILES=vimrc gitconfig bashrc
DOT_FILES_HOME=$(addprefix $(HOME)/.,$(DOT_FILES))

.PHONY: all dot-files

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
