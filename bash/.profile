#!/bin/bash

DOTFILES_PATH=~/.dotfiles
BASH_SRC_PATH=$DOTFILES_PATH/bash

. "$BASH_SRC_PATH"/.prompt
. "$BASH_SRC_PATH"/.aliases
. "$BASH_SRC_PATH"/.functions

# System Specific
. "$BASH_SRC_PATH"/.ubuntu

# Android path
export ANDROID_SDK_ROOT="/opt/android-sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools"

# golang
# export GOPATH="$HOME/.go"
# export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Solana
export PATH="$PATH:/home/hugo/.local/share/solana/install/active_release/bin"

# JAVA HOME
export JAVA_VERSION=11
export JAVA_HOME="/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64/"