#!/bin/bash


cp -Rv bash_aliases $HOME/.bash_aliases
cp -v tmux.conf ~/.tmux.conf
cp -v psqlrc ~/.psqlrc
cp -Rfv bin ~/bin
echo "source ~/.bash_aliases >> ~/.bashrc"
