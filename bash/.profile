#!/bin/bash

DOTFILES_PATH=~/.dotfiles
BASH_SRC_PATH=$DOTFILES_PATH/bash

. "$BASH_SRC_PATH"/.prompt
. "$BASH_SRC_PATH"/.aliases
. "$BASH_SRC_PATH"/.functions

# System Specific
. "$BASH_SRC_PATH"/.ubuntu

# Android path
export ANDROID_HOME="/opt/android-sdk-linux"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools"

# Composer
export PATH="$PATH:$HOME/.composer/vendor/bin"

# golang
mkdir -p "$HOME/.go"
export GOPATH="$HOME/.go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# rustup
export RUSTUP_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"
export PATH="$PATH:$CARGO_HOME/bin"

# JAVA HOME
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

# nvm and yarn
export NVM_DIR="/opt/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"

# phpbrew
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# opam
source $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# edit this folder
alias dot="cd ~/.dotfiles"
# reload
alias rl="source ~/.bashrc; echo '~/.bashrc reloaded.'"
# reset repo folder
alias rt="rm -rf ~/.dotfiles; git clone git@github.com:hmatalonga/dotfiles.git ~/.dotfiles; source ~/.bashrc"
