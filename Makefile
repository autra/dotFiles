ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DOT_FILES=vimrc gitconfig bashrc
DOT_FILES_HOME=$(addprefix $(HOME)/.,$(DOT_FILES))

.PHONY: all

all: $(DOT_FILES_HOME)

$(DOT_FILES_HOME): $(HOME)/.%: $(ROOT_DIR)/%
	ln -s $(ROOT_DIR)/$* $(HOME)/.$*
