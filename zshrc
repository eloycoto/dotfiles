# Path variables
if [ -e $HOME/bin ]; then
    export PATH=$PATH:$HOME/bin
fi

#Go things
export PATH=$PATH:$HOME/.go/bin

export GOPATH=$HOME/.go/
export GOROOT=/usr/local/go/

export EDITOR="vim"
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git virtualenvwrapper python github)
DISABLE_AUTO_UPDATE=true
DISABLE_UPDATE_PROMPT=true
source $ZSH/oh-my-zsh.sh
if [ $SSH_CONNECTION ];then
    SERVER=$(echo $SSH_CONNECTION | awk '{print $3}')
    PROMPT="${SERVER} ${PROMPT}"
fi

if [ -e $HOME/.bash_aliases ];then
    source $HOME/.bash_aliases
fi
