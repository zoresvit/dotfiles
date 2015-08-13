#!/usr/bin/env bash

# Print commands trace.
set -x

# Populate configuration files
VIMHOME="$HOME/.vim"

# Setup Vundle plugin manager.
if [ ! -d "$VIMHOME/bundle" ]
then
    echo "Setting up Vundle..."
    mkdir -p "$VIMHOME/bundle"
    git clone https://github.com/gmarik/vundle.git "$VIMHOME/bundle/vundle"
fi

# Install plugins.
vim +PluginInstall! +qall

# Setup YouCompleteMe plugin.
pushd "${HOME}/.vim/bundle/YouCompleteMe"
./install.sh --clang-completer
popd

# Install dependencies.
pip install --user --upgrade -r ${HOME}/.vim/python-requirements.txt
