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

# flutter
export PATH="$PATH:/opt/flutter/bin"

# golang
export GOPATH="$HOME/.go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# rustup
# export RUSTUP_HOME="$HOME/.rustup"
# export CARGO_HOME="$HOME/.cargo"
# export PATH="$PATH:$CARGO_HOME/bin"

# JAVA HOME
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"
# export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"

# nvm

# edit this folder
alias dot="cd ~/.dotfiles"
# reload
alias rl="source ~/.bashrc; echo '~/.bashrc reloaded.'"
# reset repo folder
alias rt="rm -rf ~/.dotfiles; git clone git@github.com:hmatalonga/dotfiles.git ~/.dotfiles; source ~/.bashrc"
