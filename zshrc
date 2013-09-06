# Path variables
if [ -e $HOME/bin ]; then
    export PATH=$PATH:$HOME/bin
fi

if [ $(uname) = "Darwin" ]; then
    export PATH=$PATH:/Library/Frameworks/Python.framework/Versions/2.7/bin/ 
fi


export EDITOR="vim"
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git virtualenvwrapper python github)
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
source $ZSH/oh-my-zsh.sh

if [ -e $HOME/.bash_aliases ];then
    source $HOME/.bash_aliases
fi
