#!/bin/bash

DOTFILES_PATH=~/.dotfiles
BASH_SRC_PATH=$DOTFILES_PATH/bash

. "$BASH_SRC_PATH"/.prompt
. "$BASH_SRC_PATH"/.aliases
. "$BASH_SRC_PATH"/.functions

# System Specific
if [[ ! "$SSH_TTY" && "$OSTYPE" =~ ^darwin ]]; then
	. "$BASH_SRC_PATH"/.osx
else
	. "$BASH_SRC_PATH"/.ubuntu
fi

# Android path
export ANDROID_HOME=/opt/android-sdk-linux
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools

# Composer
export PATH=$PATH:$HOME/.composer/vendor/bin

# golang
export GOPATH=/opt/go
export PATH=$PATH:$GOPATH/bin


# edit this folder
alias dot="cd ~/.dotfiles"
# reload
alias rl="source ~/.bashrc; echo '~/.bashrc reloaded.'"
# reset repo folder
alias rt="rm -rf ~/.dotfiles; git clone git@github.com:hmatalonga/dotfiles.git ~/.dotfiles; source ~/.bashrc"
