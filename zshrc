# Path variables
if [ -e $HOME/bin ]; then
    export PATH=$PATH:$HOME/bin
fi

export EDITOR="vim"
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="random"
plugins=(git virtualenvwrapper svn python github)
source $ZSH/oh-my-zsh.sh

if [ -e $HOME/bash_aliases ];then
    source $HOME/bash_aliases
fi
