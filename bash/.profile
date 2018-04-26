#!/bin/bash

DOTFILES_PATH=~/.dotfiles
BASH_SRC_PATH=$DOTFILES_PATH/bash

. "$BASH_SRC_PATH"/.prompt
. "$BASH_SRC_PATH"/.aliases
. "$BASH_SRC_PATH"/.functions

# System Specific
. "$BASH_SRC_PATH"/.ubuntu

# Android path
export ANDROID_HOME=/opt/android-sdk-linux
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools

# Composer
export PATH=$PATH:$HOME/.composer/vendor/bin

# golang
mkdir -p $HOME/.go
export GOPATH=$HOME/.go
export PATH=$PATH:/usr/local/go/bin

# rustup
export PATH=$PATH:$HOME/.cargo/bin

# JAVA HOME
export JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64'

export NVM_DIR="/opt/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# phpbrew
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# stack autocomplete
eval "$(stack --bash-completion-script stack)"

# edit this folder
alias dot="cd ~/.dotfiles"
# reload
alias rl="source ~/.bashrc; echo '~/.bashrc reloaded.'"
# reset repo folder
alias rt="rm -rf ~/.dotfiles; git clone git@github.com:hmatalonga/dotfiles.git ~/.dotfiles; source ~/.bashrc"
